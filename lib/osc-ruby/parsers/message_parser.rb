module OSC
  class MessageParser
    def initialize(stream, time)
      @stream = stream
      @time = time
    end

    def parse
      address = StringParser.new( @stream ).parse
      args = ArgumentParser.new( @stream ).parse

      Message.new_with_time(address, @time, nil, *args )
    end
  end
end

