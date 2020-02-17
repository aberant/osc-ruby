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

    _(ap.match?("/some/nonsense")).must_equal(true)
    _(ap.match?("/completely.different")).must_equal(true)
  end

  it "should match based on a regex" do
    ap = OSC::AddressPattern.new(/hi/)

    _(ap.match?('/hi')).must_equal(true)
    _(ap.match?('/hidden')).must_equal(true)

    _(ap.match?('/bye')).must_equal(false)
  end

  it "should return a regex if the pattern is a string" do
    ap = OSC::AddressPattern.new("/hi")

    _(ap.match?('/hi')).must_equal(true)

    _(ap.match?('   /hi')).must_equal(false)
    _(ap.match?('/ahi')).must_equal(false)
    _(ap.match?('/hidden')).must_equal(false)
    _(ap.match?('/bye')).must_equal(false)
  end

  it "should match with question mark" do
    ap = OSC::AddressPattern.new("/h?l")

    _(ap.match?('/hal')).must_equal(true)
    _(ap.match?('/hel')).must_equal(true)
    _(ap.match?('/hil')).must_equal(true)
    _(ap.match?('/hol')).must_equal(true)
    _(ap.match?('/hul')).must_equal(true)
    _(ap.match?('/hub')).must_equal(false)
  end

  it "should match with *" do
    ap = OSC::AddressPattern.new("/believ*d")

    _(ap.match?('/believd')).must_equal(true)
    _(ap.match?('/believed')).must_equal(true)
    _(ap.match?('/believeeed')).must_equal(true)
    _(ap.match?('/believaeeeioud')).must_equal(true)
    _(ap.match?('/believaeeeioud')).must_equal(true)
  end

  it "should match with []" do
    ap = OSC::AddressPattern.new("/believ[aeiou]d")

    _(ap.match?('/believad')).must_equal(true)
    _(ap.match?('/believed')).must_equal(true)
    _(ap.match?('/believid')).must_equal(true)
    _(ap.match?('/believod')).must_equal(true)
    _(ap.match?('/believud')).must_equal(true)
    _(ap.match?('/believkd')).must_equal(false)
  end

  it "should match with [!]" do
    ap = OSC::AddressPattern.new("/believ[!aeiou]d")

    _(ap.match?('/believad')).must_equal(false)
    _(ap.match?('/believed')).must_equal(false)
    _(ap.match?('/believid')).must_equal(false)
    _(ap.match?('/believod')).must_equal(false)
    _(ap.match?('/believud')).must_equal(false)
    _(ap.match?('/believkd')).must_equal(true)
    _(ap.match?('/believzd')).must_equal(true)
  end

  it "should match with {}" do
    ap = OSC::AddressPattern.new("/{hi,bye}")

    _(ap.match?('/hi')).must_equal(true)
    _(ap.match?('/bye')).must_equal(true)
    _(ap.match?('/greetings')).must_equal(false)
  end
end