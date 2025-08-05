require File.join( File.dirname(__FILE__) , '..', 'spec_helper' )

describe MessageBuilder do
  before :each do
    @builder = MessageBuilder.new
  end

  it "encodes just the address" do
    mesg = @builder.with_address("/hi")
    _(mesg.build.encode).must_equal binary_string("/hi\000,\000\000\000")
  end

  it "encodes single int values" do
    mesg = @builder.with_address("/hi").
    with_int(33)
    _(mesg.build.encode).must_equal binary_string("/hi\000,i\000\000\000\000\000!")
  end

  it "encodes single string values" do
    mesg = @builder.with_address("/hi").
    with_string("hello")

    _(mesg.build.encode).must_equal binary_string("/hi\000,s\000\000hello\000\000\000")
  end

  it "encodes single float values" do
    mesg = @builder.with_address("/hi").
    with_float(3.14159)

    _(mesg.build.encode).must_equal binary_string("/hi\000,f\000\000@I\017\320")
  end

  it "encodes multiple floats" do
    mesg = @builder.with_address("/hi").
    with_float(3.14159).
    with_float(4.5)

    _(mesg.build.encode).must_equal [47, 104, 105, 0, 44, 102, 102, 0, 64, 73, 15, 208, 64, 144, 0, 0].pack("C*")
  end

  def binary_string(val)
    String.new(val, encoding: 'BINARY')
  end
end