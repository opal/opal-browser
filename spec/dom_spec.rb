require 'spec_helper'

describe 'Kernel' do
  describe '.DOM()' do
    html <<-HTML
      <div class="spec"></div>
      <div class="sock"></div>
    HTML

    it "parses HTML" do
      expect($document['.spec'].element?).to be_truthy
      expect($document['.sock'].element?).to be_truthy
    end
  end
end
