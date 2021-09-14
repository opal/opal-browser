require 'spec_helper'
require 'browser/interval'

describe Browser::Window do
  describe '#every' do
    it 'calls the block multiple times' do
      x = 0

      promise = Browser::Promise.new
      $window.every 0.3 do
        x += 1

        if x == 3
          expect(true).to be_truthy
          promise.resolve
        end
      end
      promise.for_rspec
    end
  end
end

describe Kernel do
  describe '#every' do
    it 'calls the block multiple times' do
      x = 0

      promise = Browser::Promise.new
      every 0.3 do
        x += 1

        if x == 3
          expect(true).to be_truthy
          promise.resolve
        end
      end
      promise.for_rspec
    end
  end
end

describe Proc do
  describe '#every' do
    it 'calls the block multiple times' do
      x = 0

      promise = Browser::Promise.new
      -> {
        x += 1

        if x == 3
          expect(true).to be_truthy
          promise.resolve
        end
      }.every 0.3
      promise.for_rspec
    end
  end
end
