module OSC
  class TimestampParser
    def initialize(stream)
      @stream = stream
    end

    def parse
      #TODO: refactor this so a mortal can figure it out
      t1 = @stream.getn(4).unpack('N')[0]
      t2 = @stream.getn(4).unpack('N')[0]
      @stream.skip_padding

      if t1 == 0 && t2 == 1
        time = nil
      else
        time = t1 + t2.to_f / (2**32)
      end

      time
    end
  end
end

