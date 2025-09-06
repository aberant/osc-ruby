require File.join(File.dirname(__FILE__) , '..', 'spec_helper')

describe OSC::OSCInt32 do
  let (:val) {42}

  it "should not blow up" do
    int = OSC::OSCInt32.new(val)
    _(int.encode).must_equal(OSC::encode_int(val))
  end
end

describe OSC::OSCFloat32 do
  let (:val) {1.0}

  it "should not blow up" do
    float = OSC::OSCFloat32.new(1.0)
    _(float.encode).must_equal(OSC::encode_f32(val))
  end
end

describe OSC::OSCDouble64 do
  let (:val) {2.0}

  it "should not blow up" do
    float = OSC::OSCDouble64.new(val)
    _(float.encode).must_equal(OSC::encode_f64(val))
  end
end

describe OSC::OSCString do
  it "should not blow up" do
    OSC::OSCString.new("1")
  end
end

describe OSC::OSCBlob do
  it "should not blow up" do
    OSC::OSCBlob.new(1)
  end
end