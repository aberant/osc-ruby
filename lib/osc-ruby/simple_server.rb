module OSC
  class SimpleServer

    def initialize(port)
      @socket = UDPSocket.new
      @socket.bind('', port)
      @cb = []
      @queue = MessageQueue.new
    end
    
    def run
      start_dispatcher
      
      start_detector
    end
    
    def stop
      @socket.close
    end

    def add_method(address_pattern, &proc)
      matcher = AddressPattern.new( address_pattern )
      
      @cb << [matcher, proc]
    end

private

    def start_detector
      begin
	      detector
      rescue
	      Thread.main.raise $!
      end
    end
  
    def start_dispatcher
      Thread.fork do
	      begin
	        dispatcher
	      rescue
	        Thread.main.raise $!
	      end
      end
    end

    def sendmesg(mesg)
      @cb.each do |matcher, obj|
	      if matcher.match?( mesg.address )
	        obj.call( mesg )
	      end
      end
    end

    def dispatcher
      loop do
	      mesg = @queue.pop_event

	      sendmesg(mesg)
      end
    end

    def detector
      loop do
	      pa = @socket.recv(16384)
	      puts pa.inspect
	      begin
	        OSCPacket.messages_from_network(pa).each{|x| @queue.push(x)}
	      rescue EOFError
	      end
      end
    end

  end
end