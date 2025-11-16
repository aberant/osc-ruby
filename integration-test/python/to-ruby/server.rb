require 'bundler/setup'

$:.unshift File.join( File.dirname( __FILE__ ), '..', '..', '..', 'lib')
require 'osc-ruby'

require 'osc-ruby/server'

@server = OSC::Server.new( 3333 )

@server.add_method '/test' do | message |
  puts "#{message.ip_address}:#{message.ip_port} -- #{message.address} -- #{message.to_a}"
  puts message.encode.inspect
end


@server.run