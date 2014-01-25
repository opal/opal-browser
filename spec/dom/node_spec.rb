require 'spec_helper'

describe Browser::DOM::Node do
  describe "#==" do
    html '<div id="lol"></div>'

    it 'should work when the other argument is the native counterpart' do
      expect($document["lol"]).to eq(`document.getElementById("lol")`)
    end

    it 'should work when the other argument is the same DOM::Node' do
      el = $document["lol"]
      expect(el).to eq(el)
    end

    it 'should work when the other argument is another DOM::Node' do
      expect($document["lol"]).to eq($document["lol"])
    end
  end

  describe "#document?" do
    it "should be true for document" do
      expect($document.document?).to be_truthy
    end
  end

  describe "#element?" do
    html '<div id="lol"></div>'

    it "should be true for <div id='lol'>" do
      expect($document["#lol"].element?).to be_truthy
    end
  end

  describe "#text?" do
    html '<div id="omg">lol</div>'

    it "should be true for the first child of <div id='lol'>" do
      expect($document["#omg"].child.text?).to be_truthy
    end
  end

  describe "#ancestors" do
    html <<-HTML
      <div><span><strong><em id="incest"></em></strong></span></div>
    HTML

    it 'should get all ancestors' do
      ancestors = $document["incest"].ancestors

      expect(ancestors[0].name).to eq('STRONG')
      expect(ancestors[1].name).to eq('SPAN')
      expect(ancestors[2].name).to eq('DIV')
    end

    it 'should get only the selected ancestors' do
      expect($document["incest"].ancestors('strong').length).to eq(1)
    end
  end

  describe '#child' do
    html <<-HTML
      <div id="test-1"><div id="test-2"></div></div>
    HTML

    it 'gets the first child properly' do
      expect($document["test-1"].child.id).to eq('test-2')
    end

    it 'returns nil if there is no child' do
      expect($document["test-2"].child).to be_nil
    end
  end

  describe '#next' do
    html <<-HTML
      <div id="spec-1"></div>
      a
      <div id="spec-2"></div>
      b
      <div id="spec-3"></div>
      c
    HTML

    it 'should return the next sibling' do
      expect($document["spec-1"].next.text?).to be_truthy
      expect($document["spec-1"].next.next.id).to eq('spec-2')
    end

    it 'should return nil when there is no next sibling' do
      expect($document["spec-3"].next.text?).to be_truthy
      expect($document["spec-3"].next.next).to be_nil
    end
  end

  describe '#next_element' do
    html <<-HTML
      <div id="spec-1"></div>
      a
      <div id="spec-2"></div>
      b
      <div id="spec-3"></div>
      c
    HTML

    it 'should return the next element sibling' do
      expect($document["spec-1"].next_element.id).to eq('spec-2')
      expect($document["spec-2"].next_element.id).to eq('spec-3')
    end

    it 'should return nil when there is no next element sibling' do
      expect($document["spec-3"].next_element).to be_nil
    end
  end

  describe '#previous' do
    html <<-HTML
      a
      <div id="spec-1"></div>
      b
      <div id="spec-2"></div>
      c
      <div id="spec-3"></div>
    HTML

    it 'should return the previous sibling' do
      expect($document["spec-2"].previous.text?).to be_truthy
      expect($document["spec-2"].previous.previous.id).to eq('spec-1')
    end

    it 'should return nil when there is no previous sibling' do
      expect($document["spec-1"].previous.text?).to be_truthy
      expect($document["spec-1"].previous.previous).to be_nil
    end
  end

  describe '#previous_element' do
    html <<-HTML
      a
      <div id="spec-1"></div>
      b
      <div id="spec-2"></div>
      c
      <div id="spec-3"></div>
    HTML

    it 'should return the previous element sibling' do
      expect($document["spec-2"].previous_element.id).to eq('spec-1')
      expect($document["spec-3"].previous_element.id).to eq('spec-2')
    end

    it 'should return nil when there is no previous element sibling' do
      expect($document["spec-1"].previous_element).to be_nil
    end
  end

  describe '#inner_text' do
    html <<-HTML
      <div id="inner"><span>I like trains.</span> <span>And turtles.</span></div>
    HTML

    it 'should get the whole text for elements' do
      expect($document["inner"].inner_text).to eq('I like trains. And turtles.')
    end
  end
end
