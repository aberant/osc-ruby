require File.join( File.dirname( __FILE__ ), 'network_packet')

module OSC
  class OSCStream
    def initialize( string )
      @stream = NetworkPacket.new( string )
    end
    
    def get_string
      result = ''
      until (c = @stream.getc) == 0
	      result << c
      end
      
      @stream.skip_padding
      result
    end
    
    def get_timestamp
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