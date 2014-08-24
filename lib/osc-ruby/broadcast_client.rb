module OSC
  class BroadcastClient

    BROADCAST_ADDRESS = '<broadcast>'

    attr_reader :port

    def initialize(port)
      @port = port
      @so = UDPSocket.new
      @so.setsockopt Socket::SOL_SOCKET, Socket::SO_BROADCAST, true
    end

    def send(mesg)
      @so.send(mesg.encode, 0, BROADCAST_ADDRESS, @port)
    end
  end
end
