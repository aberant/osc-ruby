require 'osc-ruby/osc_argument'

 module OSC
  class OSCInt32 < OSCArgument

    def tag() 'i' end
    def encode() [@val].pack('N') end

  end

  class OSCFloat32 < OSCArgument

    def tag() 'f' end
    def encode() [@val].pack('g') end # fake - why fake?

  end

  class OSCString < OSCArgument

    def tag() 's' end
    def encode() padding(@val.sub(/\000.*\z/, '') + "\000") end

  end

  class OSCBlob < OSCArgument

    def tag() 'b' end
    def encode() padding([@val.size].pack('N') + @val) end

  end
end