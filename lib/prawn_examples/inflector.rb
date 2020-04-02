module PrawnExamples
  class Inflector < Zeitwerk::GemInflector
    def camelize(basename, abspath)
      if basename =~ /\d+_(.*)/
        super($1, abspath)
      else
        super
      end
    end
  end
end
