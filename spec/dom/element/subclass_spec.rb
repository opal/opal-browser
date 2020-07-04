require 'spec_helper'

describe "Browser::DOM::Element subclassing" do
  class1 = Class.new(Browser::DOM::Element) do
    def_selector ".class1"

    def hello
      "world"
    end
  end

  class2 = Class.new(Browser::DOM::Element::Input) do
    def_selector "input.class2[type='text']"

    def hello
      "goodbye"
    end
  end

  class3 = Class.new(class2) do
    def_selector "input.class2.class3[type='text']"

    def self.create(value)
      super.tap { |elem| elem.value = value }
    end
  end

  class4 = Class.new(Browser::DOM::Element) do
    def_selector "custom-element"

    def hello
      text
    end
  end

  html <<-HTML
    <div class='class1' id='hiho'></div>
    <input class='class2' type='text' id='hoho'></div>
    <input class='class2' type='hidden' id='hehe'></div>
    <custom-element id='class4'>value</custom-element>
  HTML

  it 'dispatches from DOM correctly' do
    elem = $document.at_css('#hiho')
    expect(elem.class).to eq(class1)
    expect(elem.hello).to eq('world')

    elem = $document.at_css('#hoho')
    expect(elem.class).to eq(class2)
    expect(elem.hello).to eq('goodbye')

    elem = $document.at_css('#hehe')
    expect(elem.class).to eq(Browser::DOM::Element::Input)
  end

  it 'supports creating elements correctly' do
    elem = class1.create
    expect(elem.class).to eq(class1)
    expect(elem.class_name).to eq('class1')
    expect(elem.name).to eq('DIV')
    expect(elem.hello).to eq('world')

    elem = class2.create
    expect(elem.class).to eq(class2)
    expect(elem.class_name).to eq('class2')
    expect(elem.name).to eq('INPUT')
    expect(elem.hello).to eq('goodbye')
    expect(elem.type).to eq('text')
  end

  it 'supports nested subclassing and .create overloading' do
    elem = class3.create('well')
    expect(elem.class).to eq(class3)
    expect(elem.class_name).to eq('class2 class3')
    expect(elem.value).to eq('well')
    expect(elem.hello).to eq('goodbye')
  end

  it 'supports custom elements' do
    elem = $document.at_css('#class4')
    expect(elem.class).to eq(class4)
    expect(elem.name).to eq('CUSTOM-ELEMENT')
    expect(elem.hello).to eq('value')

    elem = class4.create
    expect(elem.class).to eq(class4)
    expect(elem.name).to eq('CUSTOM-ELEMENT')
    expect(elem.hello).to eq('')
  end

  xit 'works with Paggio' do # Sadly it doesn't :(
    elem = DOM { div.class1 }
    expect(elem.class).to eq(class1)
    expect(elem.hello).to eq('world')
  end
end