require 'spec_helper'
require 'browser/interval'

describe Browser::Window do
  describe '#every' do
    async 'calls the block multiple times' do
      x = 0

      $window.every 0.3 do
        x += 1

        async {
          expect(true).to be_truthy
        } if x == 3
      end
    end
  end
end

describe Kernel do
  describe '#every' do
    async 'calls the block multiple times' do
      x = 0

      every 0.3 do
        x += 1

        async {
          expect(true).to be_truthy
        } if x == 3
      end
    end
  end
end

describe Proc do
  describe '#every' do
    async 'calls the block multiple times' do
      x = 0

      -> {
        x += 1

        async {
          expect(true).to be_truthy
        } if x == 3
      }.every 0.3
    end
  end
end
