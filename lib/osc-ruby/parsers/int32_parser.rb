module OSC
  class Int32Parser
    def initialize(stream)
      @stream = stream
    end

    def parse
      i = @stream.getn(4).unpack('N')[0]
      i -= 2**32 if i > (2**31-1)
      @stream.skip_padding
      i
    end
  end
end

