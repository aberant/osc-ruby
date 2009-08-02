require File.join( File.dirname( __FILE__ ), 'network_packet')

module OSC
  class OSCPacket
    def self.messages_from_network( string )
      messages = []
      osc = new( string )
      
      address = osc.get_string
      args = osc.get_arguments 

      messages << Message.new(address, nil, *args )
      
      
      return messages
    end
    
    def initialize( string )
      @packet = NetworkPacket.new( string )
    end
    
    def get_string
      result = ''
      until (c = @packet.getc) == 0
	      result << c
      end
      
      @packet.skip_padding
      result
    end
    
    def get_timestamp
      t1 = @packet.getn(4).unpack('N')[0]
      t2 = @packet.getn(4).unpack('N')[0]
      @packet.skip_padding
      
      if t1 == 0 && t2 == 1
        time = nil
      else
        time = t1 + t2.to_f / (2**32)
      end
      
      time
    end
    
    def get_arguments
      if @packet.getc == ?,
        
        tags = get_string
        args = []
        
        tags.scan(/./) do | tag |
          args << OSCInt32.new( get_int32 )
        end
        return nil if args.empty?
        args
      end
    end
    
    def get_int32
      i = @packet.getn(4).unpack('N')[0]
      i -= 2**32 if i > (2**31-1)
      @packet.skip_padding
      i
    end
  end
end