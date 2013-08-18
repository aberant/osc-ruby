# this script assumes that you have scsynth listening on port 4555
# make sure to change it to the port you are using
$:.unshift File.join( File.dirname( __FILE__ ), '..', 'lib')

require 'osc-ruby'
SCSYNTH_PORT = 4555

server = OSC::Server.new 5440

server.add_method "/done" do |m|
  puts m.inspect
  puts "done!"
end

server.add_method "/fail" do |m|
  puts m.inspect
  puts "fail!"
end

Thread.new {server.run}

client = OSC::BiDirectionalClient.new("127.0.0.1", SCSYNTH_PORT, server.socket)
client.send(OSC::Message.new("/notify", 1))

sleep 3
