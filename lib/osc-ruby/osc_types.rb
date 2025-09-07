require 'osc-ruby/utility/binary_string'

module OSC
  def self.encode_int(val)
    Utility::BinaryString.new([val].pack('N'))
  end

  def self.encode_f32(val)
    Utility::BinaryString.new([val].pack('g'))
  end

  def self.encode_f64(val)
    Utility::BinaryString.new([val].pack('g'))
  end

  def self.encode_string(val)
    Utility::PaddedBinaryString.new(val.sub(/\000.*\z/, '') + "\000")
  end

  def self.encode_blob(val)
    Utility::PaddedBinaryString.new([val.size].pack('N') + val)
  end

  class OSCType
    attr_accessor :val

    def initialize(val)
      @val = val
    end
  end

  class OSCInt32 < OSCType
    def tag
      'i'
    end

    def encode
      OSC::encode_int(@val)
    end
  end

  class OSCFloat32 < OSCType
    def tag
      'f'
    end

    def encode
      OSC::encode_f32(@val)
    end
  end

  class OSCDouble64 < OSCType
    def tag
      'd'
    end

    def encode
      OSC::encode_f64(@val)
    end
  end

  class OSCString < OSCType
    def tag
      's'
    end

    def encode
      OSC::encode_string(@val)
    end
  end

  class OSCBlob < OSCType
    def tag
      'b'
    end

    def encode
      OSC::encode_blob(@val)
    end
  end
end
