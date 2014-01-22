require 'spec_helper'

describe Browser::DOM::Document do
  describe '#title' do
    it 'should get the document title' do
      expect($document.title).to be_a(String)
    end
  end

  describe '#title=' do
    it 'should set the document title' do
      old = $document.title
      $document.title = 'lol'
      expect($document.title).to eq('lol')
      $document.title = old
    end
  end

  describe "#[]" do
    html <<-HTML
      <div id="lol"></div>
    HTML

    it "should get element by id" do
      expect($document["lol"]).to eq(`#{$document.to_n}.getElementById('lol')`)
    end

    it "should get element by css" do
      expect($document["lol"]).to eq(`#{$document.to_n}.getElementById('lol')`)
    end

    it "should get element by xpath" do
      expect($document["//*[@id='lol']"]).to eq(`#{$document.to_n}.getElementById('lol')`)
    end

    it "should return nil if it can't find anything" do
      expect($document["doo-dah"]).to be_nil
    end
  end
end
