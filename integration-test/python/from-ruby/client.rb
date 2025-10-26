require 'bundler/setup'

$:.unshift File.join( File.dirname( __FILE__ ), '..', '..', '..', 'lib')
require 'osc-ruby/client'
require 'osc-ruby/message'

@client = OSC::Client.new('localhost', 3333)

@client.send(OSC::Message.new("/test", 42))
@client.send(OSC::Message.new("/test", OSC::OSCFloat32.new(3.14159)))
@client.send(OSC::Message.new("/test", "Hello, World!"))
@client.send(OSC::Message.new("/test", nil))
@client.send(OSC::Message.new("/test", true))
@client.send(OSC::Message.new("/test", false))
