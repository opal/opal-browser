require 'spec_helper'

describe Browser::DOM::Node do
  describe "#==" do
    html '<div id="lol"></div>'

    it 'should work when the other argument is the native counterpart' do
      $document["lol"].should == `document.getElementById("lol")`
    end

    it 'should work when the other argument is the same DOM::Node' do
      el = $document["lol"]
      el.should == el
    end

    it 'should work when the other argument is another DOM::Node' do
      $document["lol"].should == $document["lol"]
    end
  end

  describe "#document?" do
    it "should be true for document" do
      $document.document?.should be_truthy
    end
  end

  describe "#element?" do
    html '<div id="lol"></div>'

    it "should be true for <div id='lol'>" do
      $document["#lol"].element?.should be_truthy
    end
  end

  describe "#text?" do
    html '<div id="omg">lol</div>'

    it "should be true for the first child of <div id='lol'>" do
      $document["#omg"].child.text?.should be_truthy
    end
  end

  describe "#ancestors" do
    html <<-HTML
      <div><span><strong><em id="incest"></em></strong></span></div>
    HTML

    it 'should get all ancestors' do
      ancestors = $document["incest"].ancestors

      ancestors[0].name.should == 'STRONG'
      ancestors[1].name.should == 'SPAN'
      ancestors[2].name.should == 'DIV'
    end

    it 'should get only the selected ancestors' do
      $document["incest"].ancestors('strong').length.should == 1
    end
  end

  describe '#child' do
    html <<-HTML
      <div id="test-1"><div id="test-2"></div></div>
    HTML

    it 'gets the first child properly' do
      $document["test-1"].child.id.should == "test-2"
    end

    it 'returns nil if there is no child' do
      $document["test-2"].child.should be_nil
    end
  end

  describe '#next' do
    html <<-HTML
      <div id="spec-1"></div>
      <div id="spec-2"></div>
      <div id="spec-3"></div>
    HTML

    it 'should return the next sibling' do
      $document["spec-1"].next.text?.should be_truthy
      $document["spec-1"].next.next.id.should == 'spec-2'
    end

    it 'should return nil when there is no next sibling' do
      $document["spec-3"].next.text?.should be_truthy
      $document["spec-3"].next.next.should be_nil
    end
  end

  describe '#next_element' do
    html <<-HTML
      <div id="spec-1"></div>
      <div id="spec-2"></div>
      <div id="spec-3"></div>
    HTML

    it 'should return the next element sibling' do
      $document["spec-1"].next_element.id.should == 'spec-2'
      $document["spec-2"].next_element.id.should == 'spec-3'
    end

    it 'should return nil when there is no next element sibling' do
      $document["spec-3"].next_element.should be_nil
    end
  end

  describe '#previous' do
    html <<-HTML
      <div id="spec-1"></div>
      <div id="spec-2"></div>
      <div id="spec-3"></div>
    HTML

    it 'should return the previous sibling' do
      $document["spec-2"].previous.text?.should be_truthy
      $document["spec-2"].previous.previous.id.should == 'spec-1'
    end

    it 'should return nil when there is no previous sibling' do
      $document["spec-1"].previous.text?.should be_truthy
      $document["spec-1"].previous.previous.should be_nil
    end
  end

  describe '#previous_element' do
    html <<-HTML
      <div id="spec-1"></div>
      <div id="spec-2"></div>
      <div id="spec-3"></div>
    HTML

    it 'should return the previous element sibling' do
      $document["spec-2"].previous_element.id.should == 'spec-1'
      $document["spec-3"].previous_element.id.should == 'spec-2'
    end

    it 'should return nil when there is no previous element sibling' do
      $document["spec-1"].previous_element.should be_nil
    end
  end

  describe '#inner_text' do
    html <<-HTML
      <div id="inner"><span>I like trains.</span> <span>And turtles.</span></div>
    HTML

    it 'should get the whole text for elements' do
      $document["inner"].inner_text.should == "I like trains. And turtles."
    end
  end
end
