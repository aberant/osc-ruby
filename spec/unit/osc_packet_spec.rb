require File.join( File.dirname(__FILE__) , '..', 'spec_helper' )


describe OSC::OSCPacket do
  before :each do
    @complex_packet = "#bundle\000\316\034\315T\000\003\030\370\000\000\000$/tuio/2Dobj\000,ss\000source\000\000simulator\000\000\000\000\000\000\030/tuio/2Dobj\000,s\000\000alive\000\000\000\000\000\000\034/tuio/2Dobj\000,si\000fseq\000\000\000\000\377\377\377\377"
    @simple_packet = "/hi\000,\000\000\000"
    @simple_with_integer_arg = "/hi\000,i\000\000\000\000\000*"
    
    @bundle = OSC::OSCPacket.new( @complex_packet ) 
  end
  
  it "should pull a string from the stream" do
    @bundle.get_string.should == "#bundle"
  end
  
  it "should pull a timecode from the stream" do
    @bundle.get_string
    @bundle.get_timestamp.should be_close( 3457994068.00005, 0.0001)
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
end