module OSC
  class  Server

    def initialize(port)
      @socket = UDPSocket.new
      @socket.bind('', port)
      @cb = []
      @queue = Queue.new
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
	      mesg = @queue.pop
        dispatch_message( mesg )
      end
    end

    def detector
      loop do
	      pa, network = @socket.recvfrom(16384)
	      begin
	        
	        OSCPacket.messages_from_network(pa).each do |x| 
	          @queue.push(x)
          end
          
	      rescue EOFError
	      end
      end
    end
    
    def dispatch_message( message )
      diff = ( message.time || 0 ) - Time.now.to_ntp
      
      if diff <= 0
        sendmesg( message)
      else # spawn a thread to wait until it's time
        Thread.fork do
    	    sleep(diff)
    	    sendmesg(mesg)
    	    Thread.exit
    	  end
      end
    end

  end
end