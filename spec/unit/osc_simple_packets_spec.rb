require File.join( File.dirname(__FILE__) , '..', 'spec_helper' )


describe OSC::OSCPacket do
  before :each do
    @simple_packet = "/hi\000,\000\000\000"
    @simple_with_integer_arg = "/hi\000,i\000\000\000\000\000*"
    @simple_with_two_integer_args = "/hi\000,ii\000\000\000\000*\000\000\000!"
    @simple_with_float_arg = "/hi\000,f\000\000B(\n="
    @simple_with_two_float_args = "/hi\000,ff\000B(\n=B\004\n="
    @simple_with_string_arg = "/hi\000,s\000\000greetings\000\000\000"
    @simple_with_two_string_args = "/hi\000,ss\000greetings\000\000\000how are you?\000\000\000\000"
    @simple_with_int_float_string = "/hi\000,ifs\000\000\000\000\000\000\000*B\004\n=greetings\000\000\000"
  end
  
  it "should decode the address of a simple message from the network data" do
    messages = OSC::OSCPacket.messages_from_network( @simple_packet )
    messages.should have( 1 ).item
    messages.first.should eql( OSC::Message.new( "/hi" ) )
  end
  
  it "should decode the address and int arg of a simple message from the network data" do
    messages = OSC::OSCPacket.messages_from_network( @simple_with_integer_arg )
    messages.should have( 1 ).item
    messages.first.should eql( OSC::Message.new( "/hi", "i", 42 ) )
  end
  
  it "should decode the address and two int args" do
    messages = OSC::OSCPacket.messages_from_network( @simple_with_two_integer_args )
    messages.should have( 1 ).item
    messages.first.should eql( OSC::Message.new( "/hi", "ii", 42, 33 ) )
  end
  
  it "shold decode address with float arg" do
    messages = OSC::OSCPacket.messages_from_network( @simple_with_float_arg )
    messages.should have( 1 ).item
    message = messages.first
    
    message.address.should eql( "/hi" ) 
    message.to_a.first.should be_close(42.01, 0.001)
  end
  
  it "shold decode address with two float args" do
    messages = OSC::OSCPacket.messages_from_network( @simple_with_two_float_args )
    messages.should have( 1 ).item
    message = messages.first
    
    message.address.should eql( "/hi" ) 
    args = message.to_a
    args.first.should be_close( 42.01, 0.001 )
    args[1].should be_close( 33.01, 0.0001 )
  end
  
  it "should decode address with string arg" do
    messages = OSC::OSCPacket.messages_from_network( @simple_with_string_arg )
    
    messages.first.should eql( OSC::Message.new( "/hi", "ss", "greetings" ) )
  end
  
  it "should decode address with string arg" do
    messages = OSC::OSCPacket.messages_from_network( @simple_with_two_string_args )
    
    messages.first.should eql( OSC::Message.new( "/hi", "ss", "greetings", "how are you?" ) )
  end
  
  it "should decode messages with three different types of args" do
    messages = OSC::OSCPacket.messages_from_network( @simple_with_int_float_string )
    args = messages.first.to_a
    
    args.should have(3).items
    
    args[0].should eql( 42 )
    args[1].should be_close( 33.01, 0.0001 )
    args[2].should eql( "greetings" )
  end
end