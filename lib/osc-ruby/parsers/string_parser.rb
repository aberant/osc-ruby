module OSC
  class StringParser
    def initialize(stream)
      @stream = stream
    end

    def parse
      result = ''
      until (c = @stream.getc) == string_delemeter
        result << c
      end
      @stream.skip_padding
      result
    end

    def string_delemeter
     "\x00"
    end
  end
end
