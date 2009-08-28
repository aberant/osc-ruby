# some test data for when i unit test this
# @simple_packet = "/hi\000,\000\000\000"
# @simple_with_integer_arg = "/hi\000,i\000\000\000\000\000*"
# @simple_with_two_integer_args = "/hi\000,ii\000\000\000\000*\000\000\000!"
# @simple_with_float_arg = "/hi\000,f\000\000B(\n="
# @simple_with_two_float_args = "/hi\000,ff\000B(\n=B\004\n="
# @simple_with_string_arg = "/hi\000,s\000\000greetings\000\000\000"
# @simple_with_two_string_args = "/hi\000,ss\000greetings\000\000\000how are you?\000\000\000\000"
# @simple_with_int_float_string = "/hi\000,ifs\000\000\000\000\000\000\000*B\004\n=greetings\000\000\000"

require File.join( File.dirname(__FILE__) , '..', 'spec_helper' )


describe OSC::Message do
  before :each do
    @builder = MessageBuilder.new
    @builder.with_int( 42 ).
             with_int( 33 )
             
    @message = @builder.build
  end
  
  it "should have no arguments if you define none" do
    m = OSC::Message.new( "/hi" )
    m.to_a.should == []
  end
  
  it "should have accept int arguments" do
    m = OSC::Message.new( "/hi", "i", 42 )
    m.to_a.should == [42]
    m.tags.should == "i"
  end
  
end