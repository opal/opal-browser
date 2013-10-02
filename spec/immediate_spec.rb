require 'spec_helper'
require 'browser/immediate'

describe Browser::Immediate do
  async 'defers a proc' do
    proc {|a|
      run_async {
        a.should == 42
      }
    }.defer(42)
  end
end
