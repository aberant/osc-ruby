# require File.join( File.dirname(__FILE__) , '..', 'spec_helper' )
# TODO: figure out what thread magic i need to get this to work

# describe "send and receive" do
#   it "should be able to send and receive messages" do
#     server = OSC::SimpleServer.new( 3333 )
#     
#     watcher = Object.new
#     stub( watcher ).called 
#     
#     server.add_method( "/hi") do |m|
#       watcher.called
#     end
#     
#     Thread.new do
#       server.run
#     end
# 
#     
#     client = OSC::SimpleClient.new( "localhost", 3333 )
#     client.send( OSC::Message.new( "/hi" ) )
#     
#     watcher.should have_received.called
#   end
# end