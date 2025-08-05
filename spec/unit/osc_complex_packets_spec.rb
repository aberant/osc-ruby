require File.join( File.dirname(__FILE__) , '..', 'spec_helper' )


describe OSC::OSCPacket do
  before :each do
    @complex_packet = String.new("#bundle\000\316\034\315T\000\003\030\370\000\000\000$/tuio/2Dobj\000,ss\000source\000\000simulator\000\000\000\000\000\000\030/tuio/2Dobj\000,s\000\000alive\000\000\000\000\000\000\034/tuio/2Dobj\000,si\000fseq\000\000\000\000\377\377\377\377")

    @messages = OSC::OSCPacket.messages_from_network(@complex_packet)
  end

  it "should have three messages" do
    _(@messages.size).must_equal(3)
  end

  it "should have the propper address for the messages" do
    3.times do |i|
      _(@messages[i].address).must_equal("/tuio/2Dobj")
    end
  end

  it "should have a first message with two strings" do
    args = @messages[0].to_a

    _(args[0]).must_equal("source")
    _(args[1]).must_equal("simulator")
  end

  it "should have a second message with one string" do
    args = @messages[1].to_a
    _(args[0]).must_equal("alive")
  end

  it "should have a third message with a string and an int" do
    args = @messages[2].to_a

    _(args[0]).must_equal("fseq")
    _(args[1]).must_equal(-1)
  end
end