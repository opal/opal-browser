require 'spec_helper'

describe Browser::DOM::Node do
  html <<-HTML
    <div id="spec">
      derp
    </div>
  HTML

  describe "#document?" do
    it "should be true for document" do
      $document.document?.should be_true
    end
  end

  describe "#element?" do
    it "should be true for <div id='lol'>" do
      $document["#spec"].element?.should be_true
    end
  end
end
