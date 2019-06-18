require 'ipaddr'

module OSC
  class BroadcastClient

    BROADCAST_ADDRESS = '<broadcast>'

    attr_reader :port

    def initialize(port, local_ip = nil)
      @port = port
      @so = UDPSocket.new
      @so.setsockopt Socket::SOL_SOCKET, Socket::SO_BROADCAST, true
      if local_ip
        @so.setsockopt Socket::IPPROTO_IP, Socket::IP_MULTICAST_IF, IPAddr.new(local_ip).hton
        @so.bind(local_ip, 0)
      end
    end

    def send(mesg)
      @so.send(mesg.encode, 0, BROADCAST_ADDRESS, @port)
    end
  end
end
