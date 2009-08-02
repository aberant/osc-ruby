require File.join( File.dirname(__FILE__) , '..', 'spec_helper' )


describe OSC::OSCPacket do
  before :each do
    @complex_packet = "#bundle\000\316\034\315T\000\003\030\370\000\000\000$/tuio/2Dobj\000,ss\000source\000\000simulator\000\000\000\000\000\000\030/tuio/2Dobj\000,s\000\000alive\000\000\000\000\000\000\034/tuio/2Dobj\000,si\000fseq\000\000\000\000\377\377\377\377"
    @simple_packet = "/hi\000,\000\000\000"
    @simple_with_integer_arg = "/hi\000,i\000\000\000\000\000*"
    @simple_with_two_integer_args = "/hi\000,ii\000\000\000\000*\000\000\000!"
    @simple_with_float_arg = "/hi\000,f\000\000B(\n="
    @simple_with_two_float_args = "/hi\000,ff\000B(\n=B\004\n="
    
    @bundle = OSC::OSCPacket.new( @complex_packet ) 
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
end