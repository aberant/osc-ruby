module OSC
  class SimpleServer

    def initialize(port)
      @socket = UDPSocket.new
      @socket.bind('', port)
      @cb = []
      @queue = Queue.new
    end
    
    def run
      Thread.fork do
	      begin
	        dispatcher
	      rescue
	        Thread.main.raise $!
	      end
      end
      
      begin
	      detector
      rescue
	      Thread.main.raise $!
      end
    end
    
    def stop
      @socket.close
    end

    def add_method(address_pattern, &proc)
      matcher = AddressPattern.new( address_pattern )
      
      @cb << [matcher, proc]
    end

private

    def sendmesg(mesg)
      @cb.each do |matcher, obj|
	      if matcher.match?( mesg.address )
	        obj.call( mesg )
	      end
      end
    end

    def dispatcher
      loop do
	      time, mesg = @queue.pop
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
	        Packet.decode(pa).each{|x| @queue.push(x)}
	      rescue EOFError
	      end
      end
    end

  end
end