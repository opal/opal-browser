require 'spec_helper'
require 'browser/interval'

describe Browser::Window do
  describe '#every' do
    it 'calls the block multiple times' do
      x = 0

      promise = Promise.new
      $window.every 0.3 do
        x += 1

        if x == 3
          expect(true).to be_truthy
          promise.resolve
        end
      end
      promise
    end
  end
end

describe Kernel do
  describe '#every' do
    it 'calls the block multiple times' do
      x = 0

      promise = Promise.new
      every 0.3 do
        x += 1

        if x == 3
          expect(true).to be_truthy
          promise.resolve
        end
      end
      promise
    end
  end
end

describe Proc do
  describe '#every' do
    it 'calls the block multiple times' do
      x = 0

      promise = Promise.new
      -> {
        x += 1

        if x == 3
          expect(true).to be_truthy
          promise.resolve
        end
      }.every 0.3
      promise
    end
  end
end
