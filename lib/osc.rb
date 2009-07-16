# osc.rb: Written by Tadayoshi Funaba 2005,2006
# $Id: osc.rb,v 1.4 2006-11-10 21:54:37+09 tadf Exp $

require 'forwardable'
require 'socket'
require 'thread'

require 'osc/simple_client'
require 'osc/osc_argument'
require 'osc/types'

module OSC





  class Packet

    class PO

      def initialize(str) @str, @index = str, 0 end
      def rem() @str.length - @index end
      def eof? () rem <= 0 end
      def skip(n) @index += n end
      def skip_padding() skip((4 - (@index % 4)) % 4) end

      def getn(n)
	raise EOFError if rem < n
	s = @str[@index, n]
	skip(n)
	s
      end

      def getc
	raise EOFError if rem < 1
	c = @str[@index]
	skip(1)
	c
      end

    end

    def self.decode_int32(io)
      i = io.getn(4).unpack('N')[0]
      i -= 2**32 if i > (2**31-1)
      i
    end

    def self.decode_float32(io)
      f = io.getn(4).unpack('g')[0]
      f
    end

    def self.decode_string(io)
      s = ''
      until (c = io.getc) == 0
	s << c
      end
      io.skip_padding
      s
    end

    def self.decode_blob(io)
      l = io.getn(4).unpack('N')[0]
      b = io.getn(l)
      io.skip_padding
      b
    end

    def self.decode_timetag(io)
      t1 = io.getn(4).unpack('N')[0]
      t2 = io.getn(4).unpack('N')[0]
      [t1, t2]
    end

    def self.decode2(time, packet, list)
      io = PO.new(packet)
      id = decode_string(io)
      if id =~ /\A\#/
	if id == '#bundle'
	  t1, t2 = decode_timetag(io)
	  if t1 == 0 && t2 == 1
	    time = nil
	  else
	    time = t1 + t2.to_f / (2**32)
	  end
	  until io.eof?
	    l = io.getn(4).unpack('N')[0]
	    s = io.getn(l)
	    decode2(time, s, list)
	  end
	end
      elsif id =~ /\//
	address = id
	if io.getc == ?,
	  tags = decode_string(io)
	  args = []
	  tags.scan(/./) do |t|
	    case t
	    when 'i'
	      i = decode_int32(io)
	      args << OSCInt32.new(i)
	    when 'f'
	      f = decode_float32(io)
	      args << OSCFloat32.new(f)
	    when 's'
	      s = decode_string(io)
	      args << OSCString.new(s)
	    when 'b'
	      b = decode_blob(io)
	      args << OSCBlob.new(b)
	    when /[htd]/; io.read(8)
	    when 'S'; decode_string(io)
	    when /[crm]/; io.read(4)
	    when /[TFNI\[\]]/;
	    end
	  end
	end
	list << [time, Message.new(address, nil, *args)]
      end
    end

    private_class_method :decode_int32, :decode_float32, :decode_string,
    :decode_blob, :decode_timetag, :decode2

    def self.decode(packet)
      list = []
      decode2(nil, packet, list)
      list
    end

  end

  class Message < Packet

    def initialize(address, tags=nil, *args)
      @address = address
      @args = []
      args.each_with_index do |arg, i|
	if tags && tags[i]
	  case tags[i]
	  when ?i; @args << OSCInt32.new(arg)
	  when ?f; @args << OSCFloat32.new(arg)
	  when ?s; @args << OSCString.new(arg)
	  when ?b; @args << OSCBlob.new(arg)
	  when ?*; @args << arg
	  else; raise ArgumentError, 'unknown type'
	  end
	else
	  case arg
	  when Integer;     @args << OSCInt32.new(arg)
	  when Float;       @args << OSCFloat32.new(arg)
	  when String;      @args << OSCString.new(arg)
	  when OSCArgument; @args << arg
	  end
	end
      end
    end

    attr_accessor :address

    def tags() ',' + @args.collect{|x| x.tag}.join end

    def encode
      s = OSCString.new(@address).encode
      s << OSCString.new(tags).encode
      s << @args.collect{|x| x.encode}.join
    end

    def to_a() @args.collect{|x| x.val} end

    extend Forwardable
    include Enumerable

    de = (Array.instance_methods - self.instance_methods)
    de -= %w(assoc flatten flatten! pack rassoc transpose)
    de += %w(include? sort)

    def_delegators(:@args, *de)

    undef_method :zip

  end

  class Bundle < Packet

    def encode_timetag(t)
      case t
      when NIL # immediately
	t1 = 0
	t2 = 1
      when Numeric
	t1, fr = t.divmod(1)
	t2 = (fr * (2**32)).to_i
      when Time
	t1, fr = (t.to_f + 2208988800).divmod(1)
	t2 = (fr * (2**32)).to_i
      else
	raise ArgumentError, 'invalid time'
      end
      [t1, t2].pack('N2')
    end

    private :encode_timetag

    def initialize(timetag=nil, *args)
      @timetag = timetag
      @args = args
    end

    attr_accessor :timetag

    def encode()
      s = OSCString.new('#bundle').encode
      s << encode_timetag(@timetag)
      s << @args.collect{|x|
	x2 = x.encode; [x2.size].pack('N') + x2}.join
    end

    extend Forwardable
    include Enumerable

    def to_a() @args.collect{|x| x.to_a} end

    de = (Array.instance_methods - self.instance_methods)
    de -= %w(assoc flatten flatten! pack rassoc transpose)
    de += %w(include? sort)

    def_delegators(:@args, *de)

    undef_method :zip

  end

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
      unless ( obj && !proc) ||
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
