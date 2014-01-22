require 'spec_helper'
require 'browser/immediate'

describe Proc do
  describe '#defer' do
    async 'works properly' do
      proc {|a|
        run_async {
          expect(a).to eq(42)
        }
      }.defer(42)
    end
  end
end
