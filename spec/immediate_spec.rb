require 'spec_helper'
require 'browser/immediate'

describe Proc do
  describe '#defer' do
    async 'defers the parameters' do
      proc {|a|
        async {
          expect(a).to eq(42)
        }
      }.defer(42)
    end
  end
end
