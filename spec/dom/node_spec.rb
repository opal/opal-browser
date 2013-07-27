require 'spec_helper'

describe Browser::DOM::Node do
  describe "#document?" do
    it "should be true for document" do
      DOCUMENT.document?.should be_true
    end
  end

  describe "#element?" do
    it "should be true for <div id='lol'>" do
      DOCUMENT["lol"].element?.should be_true
    end
  end
end
