require 'spec_helper'
require 'browser/immediate'

describe Proc do
  describe '#defer' do
    it 'defers the parameters' do
      promise = Browser::Promise.new
      proc {|a|
        expect(a).to eq(42)
        promise.resolve
      }.defer(42)
      promise.for_rspec
    end
  end
end if Opal::RSpec::VERSION.to_f >= 1.0
