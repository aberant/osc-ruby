require File.join( File.dirname(__FILE__) , '..', 'spec_helper' )


describe OSC::OSCStream do
  before :each do
    string = "#bundle\000\316\034\315T\000\003\030\370\000\000\000$/tuio/2Dobj\000,ss\000source\000\000simulator\000\000\000\000\000\000\030/tuio/2Dobj\000,s\000\000alive\000\000\000\000\000\000\034/tuio/2Dobj\000,si\000fseq\000\000\000\000\377\377\377\377"
    @bundle = OSC::OSCStream.new( string ) 
  end
  
  it "should pull a string from the stream" do
    @bundle.get_string.should == "#bundle"
  end
  
  it "should pull a timecode from the stream" do
    @bundle.get_string
    @bundle.get_timestamp.should be_close( 3457994068.00005, 0.0001)
  end  
  
end