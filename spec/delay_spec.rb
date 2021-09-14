require 'spec_helper'
require 'browser/delay'

describe Browser::Window do
  describe '#after' do
    it 'calls the block after the given time' do
      promise = Browser::Promise.new
      $window.after 0.3 do
        expect(true).to be_truthy
        promise.resolve
      end
      promise.for_rspec
    end
  end
end

describe Kernel do
  describe '#after' do
    it 'calls the block after the given time' do
      promise = Browser::Promise.new
      after 0.3 do
        expect(true).to be_truthy
        promise.resolve
      end
      promise.for_rspec
    end
  end
end

describe Proc do
  describe '#after' do
    it 'calls the block after the given time' do
      promise = Browser::Promise.new
      -> {
        expect(true).to be_truthy
        promise.resolve
      }.after 0.3
      promise.for_rspec
    end
  end
end
