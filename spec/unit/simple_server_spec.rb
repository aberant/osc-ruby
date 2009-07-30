require File.join( File.dirname(__FILE__) , '..', 'spec_helper' )


describe OSC::SimpleServer do
  after :each do
    
  end
  it "should not blow up" do
    ss = OSC::SimpleServer.new( 3333 )
    obj = Object.new
    
    ss.add_method( "/hi")    
    
    ss.stop
  end
end