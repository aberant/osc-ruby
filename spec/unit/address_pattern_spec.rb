require File.join(File.dirname(__FILE__) , '..', 'spec_helper')

describe OSC::AddressPattern do
  # it "..." do
  #   ap = OSC::AddressPattern.new("/bob/test/**")

  #   ap.match?("/bob/test/monkey").should be_true
  #   ap.match?("/bob/test/monkey/shine/rainy/day").should be_true

  #   ap.match?("/bob/test").should be_false
  #   ap.match?("/bob").should be_false

  # end

  it "should match anything if the pattern is nil" do
    ap = OSC::AddressPattern.new(nil)

    ap.match?("/some/nonsense").must_equal(true)
    ap.match?("/completely.different").must_equal(true)
  end

  it "should match based on a regex" do
    ap = OSC::AddressPattern.new(/hi/)

    ap.match?('/hi').must_equal(true)
    ap.match?('/hidden').must_equal(true)

    ap.match?('/bye').must_equal(false)
  end

  it "should return a regex if the pattern is a string" do
    ap = OSC::AddressPattern.new("/hi")

    ap.match?('/hi').must_equal(true)

    ap.match?('   /hi').must_equal(false)
    ap.match?('/ahi').must_equal(false)
    ap.match?('/hidden').must_equal(false)
    ap.match?('/bye').must_equal(false)
  end

  it "should match with question mark" do
    ap = OSC::AddressPattern.new("/h?l")

    ap.match?('/hal').must_equal(true)
    ap.match?('/hel').must_equal(true)
    ap.match?('/hil').must_equal(true)
    ap.match?('/hol').must_equal(true)
    ap.match?('/hul').must_equal(true)
    ap.match?('/hub').must_equal(false)
  end

  it "should match with *" do
    ap = OSC::AddressPattern.new("/believ*d")

    ap.match?('/believd').must_equal(true)
    ap.match?('/believed').must_equal(true)
    ap.match?('/believeeed').must_equal(true)
    ap.match?('/believaeeeioud').must_equal(true)
    ap.match?('/believaeeeioud').must_equal(true)
  end

  it "should match with []" do
    ap = OSC::AddressPattern.new("/believ[aeiou]d")

    ap.match?('/believad').must_equal(true)
    ap.match?('/believed').must_equal(true)
    ap.match?('/believid').must_equal(true)
    ap.match?('/believod').must_equal(true)
    ap.match?('/believud').must_equal(true)
    ap.match?('/believkd').must_equal(false)
  end

  it "should match with [!]" do
    ap = OSC::AddressPattern.new("/believ[!aeiou]d")

    ap.match?('/believad').must_equal(false)
    ap.match?('/believed').must_equal(false)
    ap.match?('/believid').must_equal(false)
    ap.match?('/believod').must_equal(false)
    ap.match?('/believud').must_equal(false)
    ap.match?('/believkd').must_equal(true)
    ap.match?('/believzd').must_equal(true)
  end

  it "should match with {}" do
    ap = OSC::AddressPattern.new("/{hi,bye}")

    ap.match?('/hi').must_equal(true)
    ap.match?('/bye').must_equal(true)
    ap.match?('/greetings').must_equal(false)
  end
end