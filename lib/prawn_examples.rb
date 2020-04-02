require_relative "prawn_examples/version"

require "prawn"

require "zeitwerk"
require_relative "prawn_examples/inflector"
loader = Zeitwerk::Loader.for_gem
loader.inflector = PrawnExamples::Inflector.new(__FILE__)
loader.enable_reloading
loader.setup
# loader.log!

require "listen"
Listen.to(__dir__) { loader.reload }.start

module PrawnExamples
  class Error < StandardError; end
  # Your code goes here...
end
