module OSC
  class SimpleServer

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
	      time = mesg.time
	      
	      now = Time.now.to_f + 2208988800
	      diff = if time.nil?
	       then 0 else time - now end
	       
	      if diff <= 0
	        sendmesg(mesg)
	      else
	        Thread.fork do
	          sleep(diff)
	          sendmesg(mesg)
	          Thread.exit
	        end
	      end
      end
    end

    def detector
      loop do
	      pa = @socket.recv(16384)
	      begin
	        OSCPacket.messages_from_network(pa).each{|x| @queue.push(x)}
	      rescue EOFError
	      end
      end
    end

  end
end