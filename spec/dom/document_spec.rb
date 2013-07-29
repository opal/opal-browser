require 'spec_helper'

describe Browser::DOM::Document do
  describe '#title' do
    it 'should get the document title' do
      $document.title.should be_kind_of(String)
    end
  end

  describe '#title=' do
    it 'should set the document title' do
      old = $document.title
      $document.title = 'lol'
      $document.title.should == 'lol'
      $document.title = old
    end
  end

  describe "#[]" do
    html <<-HTML
      <div id="lol"></div>
    HTML

    it "should get element by id" do
      $document["lol"].should == `#{$document.to_n}.getElementById('lol')`
    end

    it "should get element by css" do
      $document["lol"].should == `#{$document.to_n}.getElementById('lol')`
    end

    it "should get element by xpath" do
      $document["//*[@id='lol']"].should == `#{$document.to_n}.getElementById('lol')`
    end

    it "should return nil if it can't find anything" do
      $document["doo-dah"].should be_nil
    end
  end
end
