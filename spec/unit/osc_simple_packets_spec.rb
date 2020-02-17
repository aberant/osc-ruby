require File.join(File.dirname(__FILE__) , '..', 'spec_helper')


describe OSC::OSCPacket do
  before :each do
    @address = "/hi"
    @first_int = 42
    @second_int = 33

    @first_float = 42.01
    @second_float = 33.01

    @first_string = "greetings"
    @second_string = "how are you?"

    @first_blob = "this is a fake blob"
    @second_blob = "tis another fake blob"

    @builder = MessageBuilder.new
    @builder.with_address(@address)
  end

  it "should decode the address of a simple message from the network data" do
    sent_msg = @builder.build
    msg = OSC::OSCPacket.messages_from_network(sent_msg.encode)

    _(msg.first.address).must_equal(@address)
  end

  it "should decode the int arg of a simple message from the network data" do
    sent_msg = @builder.with_int(@first_int).build
    msg = OSC::OSCPacket.messages_from_network(sent_msg.encode)

    _(msg.first.to_a).must_equal([@first_int])
  end

  it "should decode two int args" do
    sent_msg = @builder.with_int(@first_int ).with_int( @second_int).build
    msg = OSC::OSCPacket.messages_from_network(sent_msg.encode)

    _(msg.first.to_a).must_equal([@first_int, @second_int])
  end

  it "should decode address with float arg" do
    sent_msg = @builder.with_float(@first_float).build
    msg = OSC::OSCPacket.messages_from_network(sent_msg.encode)

    _(msg.first.to_a[0]).must_be_close_to(@first_float, 0.001)
  end


  it "should decode address with two float args" do
    sent_msg = @builder.with_float(@first_float).with_float(@second_float).build
    msg = OSC::OSCPacket.messages_from_network(sent_msg.encode)

    args = msg.first.to_a
    _(args.first).must_be_close_to(@first_float, 0.001)
    _(args[1]).must_be_close_to(@second_float, 0.001)
  end

  it "should decode address with string arg" do
    sent_msg = @builder.with_string(@first_string).build
    msg = OSC::OSCPacket.messages_from_network(sent_msg.encode)

    _(msg.first.to_a).must_equal([@first_string])
  end

  it "should decode address with multiple string args" do
    sent_msg = @builder.with_string(@first_string).with_string(@second_string).build
    msg = OSC::OSCPacket.messages_from_network(sent_msg.encode)

    args = msg.first.to_a
    _(args[0]).must_equal(@first_string)
    _(args[1]).must_equal(@second_string)
  end


  it "should decode messages with three different types of args" do
    sent_msg = @builder.with_int(@first_int).
                        with_float(@second_float).
                        with_string(@first_string).
                        build

    msg = OSC::OSCPacket.messages_from_network(sent_msg.encode)

    args = msg.first.to_a

    _(args[0]).must_equal(@first_int)
    _(args[1]).must_be_close_to(@second_float, 0.001)
    _(args[2]).must_equal(@first_string)
  end

  it "should decode messages with blobs" do
    sent_msg = @builder.with_blob(@first_blob).build


    msg = OSC::OSCPacket.messages_from_network(sent_msg.encode)

    args = msg.first.to_a
    _(args.first).must_equal(@first_blob)
  end

  it "should decode messages with double64 types" do
    pi = 3.14159

    sent_msg = @builder.with_double(pi).build
    msg = OSC::OSCPacket.messages_from_network(sent_msg.encode)

    args = msg.first.to_a
    _(args.first).must_be_close_to(pi, 0.001)
  end
end