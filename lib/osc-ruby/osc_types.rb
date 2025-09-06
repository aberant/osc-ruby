require File.join(File.dirname(__FILE__), "osc_argument")

module OSC
  def self.encode_int(val)
    [val].pack('N').force_encoding("BINARY")
  end

  def self.encode_f32(val)
    [val].pack('g').force_encoding("BINARY")
  end

  def self.encode_f64(val)
    [val].pack('g').force_encoding("BINARY")
  end

  def self.encode_string(val)
    (val.sub(/\000.*\z/, '') + "\000").force_encoding("BINARY")
  end

  def self.encode_blob(val)
    ([val.size].pack('N') + val).force_encoding("BINARY")
  end

  class OSCInt32 < OSCArgument
    def tag
      'i'
    end

    def encode
      OSC::encode_int(@val)
    end
  end

  class OSCFloat32 < OSCArgument
    def tag
      'f'
    end

    def encode
      OSC::encode_f32(@val)
    end
  end

  class OSCDouble64 < OSCArgument
    def tag
      'd'
    end

    def encode
      OSC::encode_f64(@val)
    end
  end

  class OSCString < OSCArgument
    def tag
      's'
    end

    def encode
      padding(OSC::encode_string(@val))
    end
  end

  class OSCBlob < OSCArgument
    def tag
      'b'
    end

    def encode
      padding(OSC::encode_blob(@val))
    end
  end
end
