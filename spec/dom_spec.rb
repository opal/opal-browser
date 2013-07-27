require 'spec_helper'

describe Browser::DOM do
  it "generates the document" do
    DOCUMENT.document?.should be_true
  end
end
