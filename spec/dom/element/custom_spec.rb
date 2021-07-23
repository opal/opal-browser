require 'spec_helper'
require 'browser/dom/element/custom'

describe Browser::DOM::Element::Custom do
  before(:each) do
    $scratchpad = Hash.new { false }
  end

  def create_custom_class(name, observed_attrs = [])
    Class.new(Browser::DOM::Element::Custom) do
      def initialize
        super
        $scratchpad[:initialized] = true
      end

      def attached
        $scratchpad[:attached] = true
      end

      def detached
        $scratchpad[:detached] = true
      end

      def adopted
        $scratchpad[:adopted] = true
      end

      def attribute_changed(attr, from, to)
        $scratchpad[:attribute_changed] = [attr, from, to]
      end

      self.observed_attributes = observed_attrs

      def_custom name
    end
  end

  describe "upgrades" do
    html <<-HTML
      <app-ex1></app-ex1>
      <app-ex2></app-ex2>
      <app-ex7 prop="true"></app-ex7>
    HTML

    it "existing elements when they have been initialized before" do
      expect($document.at_css("app-ex1").class).to eq(Browser::DOM::Element)
      klass = create_custom_class("app-ex1")
      expect($document.at_css("app-ex1").class).to eq(klass)
      expect($scratchpad[:initialized]).to be(true)
      expect($scratchpad[:attached]).to be(true)
    end

    it "existing elements when they have not been initialized before" do
      klass = create_custom_class("app-ex2")
      expect($scratchpad[:initialized]).to be(true)
      expect($scratchpad[:attached]).to be(true)
      expect($document.at_css("app-ex2").class).to eq(klass)
    end

    it "and fires property update events when upgraded" do
      klass = create_custom_class("app-ex7", ["prop"])
      expect($scratchpad[:attribute_changed]).to eq([:prop, nil, "true"])
    end
  end

  it "creates and handles new elements correctly" do
    klass = create_custom_class("app-ex3")
    elem = klass.new
    expect($scratchpad[:initialized]).to be(true)
    expect($scratchpad[:attached]).to be(false)
    $document.body << elem
    expect($scratchpad[:detached]).to be(false)
    expect($scratchpad[:attached]).to be(true)
    elem.remove
    expect($scratchpad[:detached]).to be(true)
  end

  it "correctly tracks updated properties" do
    klass = create_custom_class("app-ex4")
    elem = klass.new
    expect($scratchpad[:attribute_changed]).to be(false)
    elem[:untracked] = "test"
    expect($scratchpad[:attribute_changed]).to be(false)

    klass = create_custom_class("app-ex5", ["tracked"])
    elem = klass.new
    expect($scratchpad[:attribute_changed]).to be(false)
    elem[:untracked] = "test"
    expect($scratchpad[:attribute_changed]).to be(false)
    elem[:tracked] = "test"
    expect($scratchpad[:attribute_changed]).to eq([:tracked, nil, "test"])
  end

  it "allows creation of custom elements in various ways" do
    klass = create_custom_class("app-ex6")

    elem = klass.new
    expect(elem).to be_a(klass)
    elem = $document.create_element("app-ex6")
    expect(elem).to be_a(klass)
    elem = DOM("<app-ex6>")
    expect(elem).to be_a(klass)
    elem = DOM { e("app-ex6") }
    expect(elem).to be_a(klass)
  end
end