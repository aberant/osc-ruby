require File.join( File.dirname(__FILE__) , '..', 'spec_helper' )


describe OSC::OSCPacket do
  before :each do
    @address = "/hi"
    @first_int = 42
    @second_int = 33
    
    @first_float = 42.01
    @second_float = 33.01
    
    @first_string = "greetings"
    @second_string = "how are you?"
    
    @first_blob = "this is a fake blob"
    @second_blob = "tis another fake blob"
    
    @builder = MessageBuilder.new
    @builder.with_address( @address )
  end
  
  it "should decode the address of a simple message from the network data" do
    sent_msg = @builder.build
    
    msg = OSC::OSCPacket.messages_from_network( sent_msg.encode )
    
    msg.first.address.should == @address
  end
  
  it "should decode the int arg of a simple message from the network data" do
    sent_msg = @builder.with_int( @first_int ).build
    
    msg = OSC::OSCPacket.messages_from_network( sent_msg.encode )
    
    msg.first.to_a.should == [@first_int]
  end
  
  it "should decode two int args" do
    sent_msg = @builder.with_int( @first_int ).with_int( @second_int ).build
    
    msg = OSC::OSCPacket.messages_from_network( sent_msg.encode )
    
    msg.first.to_a.should == [@first_int, @second_int]
  end
  
  it "shold decode address with float arg" do
    sent_msg = @builder.with_float( @first_float ).build
    
    msg = OSC::OSCPacket.messages_from_network( sent_msg.encode )
    
    msg.first.to_a[0].should be_close( @first_float, 0.001 )
  end
  
  
  it "shold decode address with two float args" do
    sent_msg = @builder.with_float( @first_float ).with_float( @second_float).build
    
    msg = OSC::OSCPacket.messages_from_network( sent_msg.encode )
    
    args = msg.first.to_a
    args.first.should be_close( @first_float, 0.001 )
    args[1].should be_close( @second_float, 0.0001 )
  end
  
  it "should decode address with string arg" do
    sent_msg = @builder.with_string( @first_string ).build
  
    msg = OSC::OSCPacket.messages_from_network( sent_msg.encode )
    
    msg.first.to_a.should == [@first_string]
  end
  
  it "should decode address with multiple string args" do
    sent_msg = @builder.with_string( @first_string ).with_string( @second_string).build
    msg = OSC::OSCPacket.messages_from_network( sent_msg.encode )
    
    args = msg.first.to_a
    args[0].should == @first_string
    args[1].should == @second_string
  end
  
  
  it "should decode messages with three different types of args" do
    sent_msg = @builder.with_int( @first_int ).
                        with_float( @second_float ).
                        with_string( @first_string ).
                        build
    
    msg = OSC::OSCPacket.messages_from_network( sent_msg.encode )
    
    args = msg.first.to_a
    
    args[0].should eql( @first_int )
    args[1].should be_close( @second_float, 0.0001 )
    args[2].should eql( @first_string )
  end
  
  it "should decode messages with blobs" do
    sent_msg = @builder.with_blob( @first_blob ).build
    
    
    msg = OSC::OSCPacket.messages_from_network( sent_msg.encode )
    
    args = msg.first.to_a
    args.first.should eql( @first_blob )
  end
end