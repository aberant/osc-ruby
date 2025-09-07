require 'spec_helper'
require 'osc-ruby/osc_types'

describe OSC::OSCInt32 do
  let (:val) {42}

  it "should not blow up" do
    int = OSC::OSCInt32.new(val)
    output = int.encode
    
    _(output.encoding).must_equal(Encoding.find("BINARY"))
    _(output).must_equal(OSC::encode_int(val))
  end
end

describe OSC::OSCFloat32 do
  let (:val) {1.0}

  it "should not blow up" do
    float = OSC::OSCFloat32.new(1.0)
    output = float.encode

    _(output.encoding).must_equal(Encoding.find("BINARY"))
    _(output).must_equal(OSC::encode_f32(val))
  end
end

describe OSC::OSCDouble64 do
  let (:val) {2.0}

  it "should not blow up" do
    float = OSC::OSCDouble64.new(val)
    output = float.encode

    _(output.encoding).must_equal(Encoding.find("BINARY"))
    _(float.encode).must_equal(OSC::encode_f64(val))
  end
end

describe OSC::OSCString do
  let (:val) {"Hello, World!"}

  it "should not blow up" do
    str = OSC::OSCString.new(val)
    output = str.encode

    _(output.encoding).must_equal(Encoding.find("BINARY"))
    _(output.start_with?(OSC::encode_string(val))).must_equal(true)
  end
end

describe OSC::OSCBlob do
    let(:val) {"bob the blob"}

  it "should not blow up" do
    blob = OSC::OSCBlob.new(val)
    output = blob.encode

    _(output.encoding).must_equal(Encoding.find("BINARY"))
    _(output).must_include(OSC::encode_blob(val))
  end
end