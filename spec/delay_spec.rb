require 'spec_helper'
require 'browser/delay'

describe Browser::Window do
  describe '#after' do
    async 'calls the block after the given time' do
      $window.after 0.3 do
        async {
          expect(true).to be_truthy
        }
      end
    end
  end
end

describe Kernel do
  describe '#after' do
    async 'calls the block after the given time' do
      after 0.3 do
        async {
          expect(true).to be_truthy
        }
      end
    end
  end
end

describe Proc do
  describe '#after' do
    async 'calls the block after the given time' do
      -> {
        async {
          expect(true).to be_truthy
        }
      }.after 0.3
    end
  end
end
