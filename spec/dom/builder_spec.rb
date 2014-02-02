require 'spec_helper'

describe Browser::DOM::Builder do
  it 'builds an element' do
    res = DOM {
      div
    }

    expect(res.name).to eq('DIV')
  end

  it 'builds an element with text content' do
    res = DOM {
      div "foo bar"
    }

    expect(res.text).to eq('foo bar')

    res = DOM {
      div {
        "foo bar"
      }
    }

    expect(res.text).to eq('foo bar')
  end

  it 'builds an element with attributes' do
    res = DOM {
      div class: :wut
    }

    expect(res.class_name).to eq(:wut)
  end

  it 'builds deeper trees' do
    res = DOM {
      div {
        span {
          "wut"
        }
      }
    }

    expect(res.name).to eq('DIV')
    expect(res.child.name).to eq('SPAN')
    expect(res.child.text).to eq('wut')
  end

  it 'sets classes with methods' do
    expect(DOM {
      div.nice.element
    }.class_names).to eq(%w[nice element])
  end

  it 'nests when setting classes' do
    res = DOM {
      div.nice.element {
        span.nicer 'lol'
      }
    }

    expect(res.name).to eq('DIV')
    expect(res.class_names).to eq(%w[nice element])
    expect(res.child.name).to eq('SPAN')
    expect(res.child.class_names).to eq(%w[nicer])
  end

  it 'joins class name properly' do
    res = DOM {
      i.icon[:legal]
    }

    expect(res.name).to eq('I')
    expect(res.class_names).to eq(%w[icon-legal])
  end

  it 'sets the id' do
    res = DOM {
      div.omg!
    }

    expect(res.name).to eq('DIV')
    expect(res.id).to eq('omg')
  end
end
