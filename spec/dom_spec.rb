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

    it "appends classes correctly" do
      elem = DOM {
        div.class1.class2(class: "class-3 class-4", classes: %w[class-5 class-6])
      }

      expect(elem =~ ".class1.class2.class-3.class-4.class-5.class-6").to eq(true)
    end
  end
end
