require File.join( File.dirname(__FILE__) , '..', 'spec_helper' )

describe OSC::SimpleClient do
  it "should not blow up" do
    udp = Object.new
    stub( udp ).connect
    stub( UDPSocket ).new.returns( udp )
    
    OSC::SimpleClient.new( "localhost", 3333 )
  end
end