require 'spec_helper'

describe Browser::CSS::Builder do
  it 'builds a rule' do
    css = Browser::CSS::Builder.new do
      rule '#lol' do
        color 'black'
      end
    end

    css.to_s.should == "#lol {\n\tcolor: black;\n}\n\n"
  end
end
