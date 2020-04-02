require "socket"

require_relative "prawn_examples"

require "pathname"

class HttpServer
  EXAMPLE_FILES =
    Dir[File.join(__dir__, "prawn_examples", "*.rb")] \
      .map { |f| Pathname(f).expand_path } \
      .filter { |pn| pn.basename.to_s.start_with?(/\d/) } \
      .sort

  EXAMPLE_KLASSES =
    EXAMPLE_FILES.map { |pn| pn.basename.to_s.sub(/\A\d+_(.*)\.rb\z/, '\1') }

  def start(port)
    server = TCPServer.new port
    loop do
      client = server.accept # Wait for a client to connect

      response = parse_request(client)
      client.puts format_response(response)

      client.close
    end
  end

  def parse_request(client_socket)
    request_line = client_socket.readline.chomp
    request_path = request_line.split(" ")[1]
    (klass, method) = request_path \
      .delete_prefix("/")
      .delete_suffix("/")
      .split("/")

    klass = (klass || "").split("_").map { |s| s.capitalize }.join
    klass = EXAMPLE_KLASSES.include?(klass) ? klass : "BasicConcepts"
    klass = PrawnExamples.const_get(klass)

    method = klass.instance_methods(false).map(&:to_s).include?(method) ? method : "origin"

    pdf = klass.new
    pdf.send(method)
    pdf.render
  end

  def format_response(response)
    <<~EOS
      HTTP/1.1 200 OK\r
      Content-Type: application/pdf\r
      Content-Length: #{response.bytesize}\r
      \r
      #{response}
    EOS
  end
end

HttpServer.new.start(2000)
