require File.join( File.dirname(__FILE__) , '..', 'spec_helper' )

describe OSC::MessageQueue do

  before :each do
    @queue = OSC::MessageQueue.new
  end 
  
  describe "queueing messages" do
    before :each do
      @address = "/command"
      now = Time.now
      
      @builder = MessageBuilder.new
      @builder.with_address( @address )
      
      @oldest = @builder.build
      @oldest.time = now + 10.seconds
      
      @newest = @builder.build
      @newest.time = nil
      
      @middle = @builder.build
      @middle.time = now + 5.seconds
    end
    
    it "should pop in the right order" do
      pending "until i figure out the impl of the queue i want"
      @queue.push( @oldest )
      @queue.push( @newest )
      @queue.push( @middle )
      
      @queue.pop_event.should == @newest
      @queue.pop_event.should == @middle
      @queue.pop_event.should == @oldest
    end
  end
  
end