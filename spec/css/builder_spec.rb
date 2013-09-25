require 'spec_helper'

describe Browser::CSS::Builder do
  it 'builds a rule' do
    css = Browser::CSS::Builder.new do
      rule '#lol' do
        color 'black'
      end
    end

    css.to_s.should == "#lol {\n\tcolor: black;\n}"
  end

  it 'builds border-radius correctly' do
    css = Browser::CSS::Builder.new do
      rule '#lol' do
        border radius: '5px'
      end
    end

    css.to_s.should == "#lol {\n\t-moz-border-radius: 5px;\n\t-webkit-border-radius: 5px;\n\tborder-radius: 5px;\n}"
  end

  it 'builds box-shadow correctly' do
    css = Browser::CSS::Builder.new do
      rule '#lol' do
        box shadow: '0 0 5px black'
      end
    end

    css.to_s.should == "#lol {\n\t-moz-box-shadow: 0 0 5px black;\n\t-webkit-box-shadow: 0 0 5px black;\n\tbox-shadow: 0 0 5px black;\n}"
  end

end
