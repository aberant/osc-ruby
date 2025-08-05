require File.join(File.dirname(__FILE__) , '..', 'spec_helper')


describe OSC::NetworkPacket do
  before :each do
    @empty = OSC::NetworkPacket.new("".dup)
    @simple = OSC::NetworkPacket.new("abc".dup)
  end

  it "should know if it's at the end of the stream" do
    _(@empty.eof?).must_equal(true)
  end

  it "should know the remainder in the stream" do
    _(@simple.rem).must_equal(3)
  end

  it "should be able to skip positions" do
    @simple.skip(1)
    _(@simple.rem).must_equal(2)
  end

  it "should be able to get a character from the stream" do
    _(@simple.getc).must_equal(?a)
    _(@simple.getc).must_equal(?b)
    _(@simple.getc).must_equal(?c)
    _(@simple.eof?).must_equal(true)
  end

  it "should be able to get a number of characters from the stream" do
    _(@simple.getn(3)).must_equal("abc")
  end

  it "outputs characters with ASCII/BINARY encoding" do
    _(@simple.getc.encoding.to_s).must_equal("ASCII-8BIT")
  end
end
