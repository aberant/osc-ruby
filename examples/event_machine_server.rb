# compatible with ruby 1.8, 1.9, and jruby
require File.join( File.dirname( __FILE__ ), '..', 'lib', 'osc-ruby', 'em_server' )

@server = OSC::EMServer.new( 3333 )
@client = OSC::Client.new( 'localhost', 3333 )

@server.add_method '/greeting' do | message |
  puts message.to_a
end

Thread.new do
  @server.run
end

@client.send( OSC::Message.new( "/greeting" , "hullo!" ))

sleep( 3 )