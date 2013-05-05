module OSC
  class ArgumentParser
    def initialize(stream)
      @stream = stream
      # TODO: must expand this to required types for 1.1
      # TODO: expand to allow for user submitted types to work
      
      @types = { "i" => lambda{  OSCInt32.new( Int32Parser.new(@stream).parse ) },
           "f" => lambda{  OSCFloat32.new( Float32Parser.new(@stream).parse ) },
           "s" => lambda{  OSCString.new( StringParser.new(@stream).parse ) },
           "b" => lambda{  OSCBlob.new( BlobParser.new(@stream).parse )}
          }
    end

    def parse
      if @stream.getc == ?,

        tags = StringParser.new(@stream).parse
        args = []

        tags.scan(/./) do | tag |
          args << @types[tag].call
        end
        args
      end
    end
  end
end

