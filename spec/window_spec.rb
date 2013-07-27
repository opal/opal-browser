require 'spec_helper'

describe Browser::Window do
  describe '#document' do
    it 'should return `document`' do
      $window.document.should == `document`
      $window.document.class.should == Browser::DOM::Document
    end
  end
end
