require 'osc-ruby'
# /tuio/2Dobj

ss = OSC::SimpleServer.new( 3333 )
ss.add_method( '*' ) do |msg|
  puts msg.inspect
end

ss.run
sleep
