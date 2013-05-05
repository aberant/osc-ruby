module OSC
  class BlobParser
    def initialize(stream)
      @stream = stream
    end

    def parse
      l = @packet.getn(4).unpack('N')[0]
      b = @packet.getn(l)
      @packet.skip_padding
      b
    end
  end
end