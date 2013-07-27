require 'spec_helper'

describe Browser::DOM::Element do
  describe "#[]" do
    it "should get element by id" do
      DOCUMENT["lol"].should == `#{DOCUMENT.to_n}.getElementById('lol')`
    end

    it "should get element by css" do
      DOCUMENT["#lol"].should == `#{DOCUMENT.to_n}.getElementById('lol')`
    end

    it "should get element by xpath" do
      DOCUMENT["//*[@id='lol']"].should == `#{DOCUMENT.to_n}.getElementById('lol')`
    end
  end
end
