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
end
