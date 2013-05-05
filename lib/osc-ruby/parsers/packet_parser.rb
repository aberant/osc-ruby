module OSC
  class PacketParser
    # TODO: add ip info back in
    
    def self.from_binary(string, time=nil)
      new(NetworkPacket.new( string ), time).parse.flatten
    end

    def initialize(stream, time=nil)
      @stream = stream
      @time = time
    end

    def parse
      if @stream.bundle_packet?
        time, bundles = BundleParser.new(@stream).parse
        bundles.map do |bundle|
          PacketParser.from_binary(bundle, @time)
        end

      else
        [MessageParser.new(@stream, @time).parse]
      end
    end
  end
end

