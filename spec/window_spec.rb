require 'spec_helper'

describe Browser::Window do
  describe '#document' do
    it 'should return `document`' do
      expect($window.document).to eq(`document`)
      expect($window.document.class).to eq(Browser::DOM::Document)
    end
  end
end
