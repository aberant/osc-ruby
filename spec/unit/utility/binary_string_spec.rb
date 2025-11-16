require 'spec_helper'

describe OSC::Utility::BinaryString do 
  let (:val) {String.new('Rock Lobster')}
  let (:bstring) { OSC::Utility::BinaryString.new(val)}

  it "has a working ==" do 
    _(bstring == val).must_equal(true)  
  end

  it "has a working +" do
    result = bstring + "!"

    _(result).must_equal("Rock Lobster!")  
    _(result.encoding).must_equal(Encoding.find("BINARY"))
  end

  it "has a binary encoding" do
    _(bstring.encoding).must_equal(Encoding.find("BINARY"))
  end

  it "has a size" do
    _(bstring.size).must_equal(12)
  end

  it "has a concat" do
      bstring << "!"

    _(bstring).must_equal("Rock Lobster!")  
  end
end

describe OSC::Utility::PaddedBinaryString do
  let (:val) {String.new('Rock Lobster!')}
  let (:pbstring) { OSC::Utility::PaddedBinaryString.new(val)}

  it "has a size padded to multiples of 4" do
    _(pbstring.size).must_equal(16)
  end

  it "is padded with null characters" do
    _(pbstring).must_include("\x00\x00\x00")
  end
end
