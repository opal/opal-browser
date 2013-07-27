require 'spec_helper'

describe Browser::DOM::Element do
  html <<-HTML
    <div id="lol"></div>
  HTML

  describe "#[]" do
    it "should get element by id" do
      $document["lol"].should == `#{$document.to_n}.getElementById('lol')`
    end

    it "should get element by css" do
      $document["lol"].should == `#{$document.to_n}.getElementById('lol')`
    end

    it "should get element by xpath" do
      $document["//*[@id='lol']"].should == `#{$document.to_n}.getElementById('lol')`
    end
  end
end
