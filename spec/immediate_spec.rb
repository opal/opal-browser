require 'spec_helper'
require 'browser/immediate'

describe Proc do
  describe '#defer' do
    async 'works properly' do
      proc {|a|
        run_async {
          a.should == 42
        }
      }.defer(42)
    end
  end
end
