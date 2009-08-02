module OSC
  class Packet

    class PO
      def initialize(str) 
        @str, @index = str, 0 
      end
      
      def rem() 
        @str.length - @index 
      end
      
      def eof? () 
        rem <= 0 
      end
      
      def skip(n) 
        @index += n 
      end
      
      def skip_padding() 
        skip((4 - (@index % 4)) % 4) 
      end

      def getn(n)
      	raise EOFError if rem < n
      	s = @str[@index, n]
      	skip(n)
      	s
      end

      def getc
      	raise EOFError if rem < 1
      	c = @str[@index]
      	skip(1)
      	c
      end
    end

    def self.decode_int32(io)
      i = io.getn(4).unpack('N')[0]
      i -= 2**32 if i > (2**31-1)
      i
    end

    def self.decode_float32(io)
      f = io.getn(4).unpack('g')[0]
      f
    end

    def self.decode_string(io)
      s = ''
      until (c = io.getc) == 0
	      s << c
      end
      io.skip_padding
      s
    end

    def self.decode_blob(io)
      l = io.getn(4).unpack('N')[0]
      b = io.getn(l)
      io.skip_padding
      b
    end

    def self.decode_timetag(io)
      t1 = io.getn(4).unpack('N')[0]
      t2 = io.getn(4).unpack('N')[0]
      [t1, t2]
    end

    def self.decode2(time, packet, list)
      io = PO.new(packet)
      id = decode_string(io)
      if id =~ /\A\#/
	      if id == '#bundle'
	        t1, t2 = decode_timetag(io)
	        if t1 == 0 && t2 == 1
	          time = nil
	        else
	          time = t1 + t2.to_f / (2**32)
	        end
	        until io.eof?
	          l = io.getn(4).unpack('N')[0]
	          s = io.getn(l)
	          decode2(time, s, list)
	        end
	      end
      elsif id =~ /\//
        address = id
        if io.getc == ?,
          tags = decode_string(io)
          args = []
          tags.scan(/./) do |t|
            case t
             when 'i'
               i = decode_int32(io)
               args << OSCInt32.new(i)
             when 'f'
               f = decode_float32(io)
               args << OSCFloat32.new(f)
             when 's'
               s = decode_string(io)
               args << OSCString.new(s)
             when 'b'
               b = decode_blob(io)
               args << OSCBlob.new(b)
             when /[htd]/; io.read(8)
             when 'S'; decode_string(io)
             when /[crm]/; io.read(4)
             when /[TFNI\[\]]/;
            end
	        end
	        list << [time, Message.new(address, nil, *args)]
        end
      end
    end
    
    private_class_method  :decode_int32, 
                          :decode_float32, 
                          :decode_string, 
                          :decode_blob, 
                          :decode_timetag, 
                          :decode2

    def self.decode(packet)
      list = []
      decode2(nil, packet, list)
      list
    end

  end
end