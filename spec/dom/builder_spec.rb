require 'spec_helper'

describe Browser::DOM::Builder do
  it 'builds an element' do
    DOM {
      div
    }.name.should == 'DIV'
  end

  it 'builds an element with text content' do
    DOM {
      div "foo bar"
    }.text.should == "foo bar"

    DOM {
      div {
        "foo bar"
      }
    }.text.should == "foo bar"
  end

  it 'builds an element with attributes' do
    DOM {
      div class: :wut
    }.class_name.should == :wut
  end

  it 'builds deeper trees' do
    res = DOM {
      div {
        span {
          "wut"
        }
      }
    }

    res.name.should == 'DIV'
    res.child.name.should == 'SPAN'
    res.child.text.should == 'wut'
  end

  it 'sets classes with methods' do
    DOM {
      div.nice.element
    }.class_names.should == %w[nice element]
  end

  it 'nests when setting classes' do
    res = DOM {
      div.nice.element {
        span.nicer 'lol'
      }
    }

    res.name.should == 'DIV'
    res.class_names.should == %w[nice element]
    res.child.name.should == 'SPAN'
    res.child.class_names.should == %w[nicer]
  end

  it 'joins class name properly' do
    res = DOM {
      i.icon[:legal]
    }

    res.name.should == 'I'
    res.class_names.should == %w[icon-legal]
  end
end
