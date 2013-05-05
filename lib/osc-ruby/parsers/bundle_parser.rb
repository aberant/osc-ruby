module OSC
  class BundleParser
    def initialize(stream)
      @stream = stream
    end

    def parse
      skip_bundle_header
      time = TimestampParser.new(@stream).parse
      bundle_messages = []


      until @stream.eof?
        l = @stream.getn(4).unpack('N')[0]
        bundle_messages << @stream.getn(l)
      end
      
      [time, bundle_messages]
    end

    def skip_bundle_header
      StringParser.new(@stream).parse
    end
  end
end
