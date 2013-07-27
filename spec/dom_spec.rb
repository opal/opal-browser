require 'spec_helper'

describe Browser::DOM do
  html <<-HTML
    <div class="spec"></div>
    <div class="sock"></div>
  HTML

  it "parses the HTML" do
    $document['.spec'].element?.should be_true
    $document['.sock'].element?.should be_true
  end
end
