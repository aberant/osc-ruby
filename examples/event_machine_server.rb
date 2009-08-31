require File.join( File.dirname( __FILE__ ), '..', 'lib', 'osc-ruby', 'em_server' )

@server = OSC::EMServer.new

@server.add_method '/tuio/2Dobj' do |msg|
  puts msg.inspect
end

@server.run