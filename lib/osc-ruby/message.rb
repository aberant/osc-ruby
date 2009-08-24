module OSC
  class Message < Packet
    extend Forwardable
    include Enumerable

    attr_accessor :address
    attr_accessor :time 
    
    undef_method :zip

    de = (Array.instance_methods - self.instance_methods)
    de -= %w(assoc flatten flatten! pack rassoc transpose)
    de += %w(include? sort)
    # puts de.inspect
    # 
    def_delegators(:@args, *de)
    
    def self.new_with_time( address, time, tags=nil, *args )
      message = new( address, tags, *args )
      message.time = time
      message
    end
    
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


    def tags() @args.collect{|x| x.tag}.join end

    def encode
      s = OSCString.new( @address ).encode
      s << OSCString.new( ',' + tags ).encode
      s << @args.collect{|x| x.encode}.join
    end

    def to_a() @args.collect{|x| x.val} end
      
    def eql?( other )
      @address == other.address &&
      to_a == other.to_a
    end
  end
end