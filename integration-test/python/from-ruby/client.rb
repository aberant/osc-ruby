require 'bundler/setup'

$:.unshift File.join( File.dirname( __FILE__ ), '..', '..', '..', 'lib')
require 'osc-ruby/client'
require 'osc-ruby/message'
require 'osc-ruby/bundle'

immediate = nil

client = OSC::Client.new('localhost', 3333)
int_msg = OSC::Message.new("/test", 42)
float_msg = OSC::Message.new("/test", OSC::OSCFloat32.new(3.14159))
string_msg = OSC::Message.new("/test", "Hello, World!")
nil_msg = OSC::Message.new("/test", nil)
true_msg = OSC::Message.new("/test", true)
false_msg = OSC::Message.new("/test", false)

client.send(int_msg)
client.send(float_msg)
client.send(string_msg)
client.send(nil_msg)
client.send(true_msg)
client.send(false_msg)

bundle = OSC::Bundle.new(immediate, int_msg, float_msg, string_msg, nil_msg, true_msg, false_msg)
client.send(bundle)