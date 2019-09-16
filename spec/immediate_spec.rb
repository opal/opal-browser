require 'spec_helper'
require 'browser/immediate'

describe Proc do
  describe '#defer' do
    it 'defers the parameters' do
      promise = Promise.new
      proc {|a|
        expect(a).to eq(42)
        promise.resolve
      }.defer(42)
      promise
    end
  end
end
