require 'spec_helper'
require 'osc-ruby/message'

describe OSC::Message do
  describe "basic traits" do
    it "should have no arguments if you define none" do
      m = OSC::Message.new("/hi")
      _(m.to_a).must_equal([])
    end

    it "should accept int arguments" do
      m = OSC::Message.new("/hi", 42)
      _(m.to_a).must_equal([42])
      _(m.tags).must_equal("i")
    end

    it "should accept string arguments" do
      m = OSC::Message.new("/hi", "42")
      _(m.to_a).must_equal(["42"])
      _(m.tags).must_equal("s")
    end

    it "should accept float arguments" do
      m = OSC::Message.new("/hi", 42.001)
      _(m.to_a).must_equal([42.001])
      _(m.tags).must_equal("f")
    end

    it "should accept nil arguments" do
      m = OSC::Message.new("/hi", nil)
      _(m.to_a).must_equal([nil])
      _(m.tags).must_equal("N")
    end
  end

  describe "message output encoding" do
    it "integer arguments output binary/ascii string" do
      m = OSC::Message.new("/hi", 42).encode
      _(m.encoding.to_s).must_equal("ASCII-8BIT")
    end

    it "string arguments output binary/ascii string" do
      m = OSC::Message.new("/hi", "42").encode
      _(m.encoding.to_s).must_equal("ASCII-8BIT")
    end

    it "float arguments output binary/ascii string" do
      m = OSC::Message.new("/hi", 3.14159).encode
      _(m.encoding.to_s).must_equal("ASCII-8BIT")
    end
  end

  describe "more interesting traits" do
    before :each do
      @builder = MessageBuilder.new
      @builder.with_int(42).
               with_int(33)

      @message = @builder.build
    end

    it "should know equality" do
      @message2 = @builder.build

      _(@message.object_id).wont_equal(@message2.object_id)
      _(@message).must_equal(@message2)
    end
  end
end