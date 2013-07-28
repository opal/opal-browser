require 'spec_helper'

describe Browser::DOM::Node do
  describe "#document?" do
    it "should be true for document" do
      $document.document?.should be_true
    end
  end

  describe "#element?" do
    html <<-HTML
      <div id="lol">
        <div id="omg"></div>
      </div>
    HTML

    it "should be true for <div id='lol'>" do
      $document["#omg"].element?.should be_true
    end
  end

  describe "#text?" do
    html <<-HTML
      <div id="herp">
        derp
      </div>
    HTML

    it "should be true for the first child of <div id='herp'>" do
      $document["#herp"].child.text?.should be_true
    end
  end
end
