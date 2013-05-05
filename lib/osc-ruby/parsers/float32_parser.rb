module OSC
  class Float32Parser
    def initialize(stream)
      @stream = stream
    end

    def parse
      f = @stream.getn(4).unpack('g')[0]
      @stream.skip_padding
      f
    end
  end
end

