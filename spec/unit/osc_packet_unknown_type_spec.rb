require File.join(File.dirname(__FILE__) , '..', 'spec_helper')

describe OSC::OSCPacket do
  it 'something' do
    class OSC::BadType < OSC::OSCInt32; def tag() 'Z'; end end
    sent_msg = OSC::Message.new("/badtype", OSC::BadType.new(42))

    _ {OSC::OSCPacket.messages_from_network(sent_msg.encode)}.must_raise OSC::UnknownType
  end
end