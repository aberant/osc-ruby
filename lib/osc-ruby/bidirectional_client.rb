module OSC
  class BiDirectionalClient
    def initialize( host, port, socket )
      @socket = socket
      @host = host
      @port = port
    end

    def send(mesg)
      @socket.send(mesg.encode, 0, @host, @port)
    end
  end
end