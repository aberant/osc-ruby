module OSC
  module Utility
    class BinaryString
      def initialize(string)
        @string = string.force_encoding("BINARY")
      end

      def ==(other)
        @string == other
      end

      def +(other)
        (@string + other)
      end

      def encoding
        @string.encoding
      end

      def include?(other)
        @string.include?(other)
      end

      def to_str
        @string
      end

      def size
        @string.size
      end
    end

    class PaddedBinaryString < BinaryString
      def initialize(string)
        super(string + ("\000" * ((4 - (string.size % 4)) % 4)))
      end
    end
  end
end