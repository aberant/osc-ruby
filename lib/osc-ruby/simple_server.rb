module OSC
  class SimpleServer

    def initialize(port)
      @so = UDPSocket.new
      @so.bind('', port)
      @cb = []
      @qu = Queue.new
    end

    def add_method(pat, obj=nil, &proc)
      case pat
        when NIL; re = pat
        when Regexp; re = pat
        when String
	        pat = pat.dup
	        pat.gsub!(/[.^(|)]/, '\\1')
	        pat.gsub!(/\?/, '[^/]')
	        pat.gsub!(/\*/, '[^/]*')
	        pat.gsub!(/\[!/, '[^')
	        pat.gsub!(/\{/, '(')
	        pat.gsub!(/,/, '|')
	        pat.gsub!(/\}/, ')')
	        pat.gsub!(/\A/, '\A')
	        pat.gsub!(/\z/, '\z')
	        re = Regexp.new(pat)
        else
	        raise ArgumentError, 'invalid pattern'
      end
      
      unless  ( obj && !proc) ||
	            (!obj &&  proc)
	      raise ArgumentError, 'wrong number of arguments'
      end
      @cb << [re, (obj || proc)]
    end

    def sendmesg(mesg)
      @cb.each do |re, obj|
	      if re.nil? || re =~ mesg.address
	        obj.send(if Proc === obj then :call else :accept end, mesg)
	      end
      end
    end

    def dispatcher
      loop do
	      time, mesg = @qu.pop
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
	      pa = @so.recv(16384)
	      begin
	        Packet.decode(pa).each{|x| @qu.push(x)}
	      rescue EOFError
	      end
      end
    end

    private :sendmesg, :dispatcher, :detector

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
  end
end