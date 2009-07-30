require File.join( File.dirname(__FILE__) , '..', 'spec_helper' )

describe OSC::AddressPattern do
  it "should match anything if the pattern is nil" do
    ap = OSC::AddressPattern.new( nil )
    
    ap.match?( "/some/nonsense").should be_true
    ap.match?( "/completely.different").should be_true
  end
  
  it "should match based on a regex" do
    ap = OSC::AddressPattern.new( /hi/ )
    
    ap.match?( '/hi' ).should be_true
    ap.match?( '/hidden' ).should be_true
    
    ap.match?( '/bye' ).should be_false
  end 
  
  it "should return a regex if the pattern is a string" do
    ap = OSC::AddressPattern.new( "/hi" )
    
    ap.match?('/hi').should be_true
    ap.match?( '/hidden' ).should be_true
    
    ap.match?( '/bye' ).should be_false
  end
end