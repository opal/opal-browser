require 'spec_helper'

describe Browser::DOM::Node do
  describe "#document?" do
    it "should be true for document" do
      $document.document?.should be_true
    end
  end

  describe "#element?" do
    html <<-HTML
      <div id="lol">
        <div id="omg"></div>
      </div>
    HTML

    it "should be true for <div id='lol'>" do
      $document["#omg"].element?.should be_true
    end
  end

  describe "#text?" do
    html <<-HTML
      <div id="herp">
        derp
      </div>
    HTML

    it "should be true for the first child of <div id='herp'>" do
      $document["#herp"].child.text?.should be_true
    end
  end

  describe '#next' do
    html <<-HTML
      <div id="spec-1"></div>
      <div id="spec-2"></div>
      <div id="spec-3"></div>
    HTML

    it 'should return the next sibling' do
      $document["spec-1"].next.text?.should be_true
      $document["spec-1"].next.next.id.should == 'spec-2'
    end

    it 'should return nil when there is no next sibling' do
      $document["spec-3"].next.text?.should be_true
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
      $document["spec-2"].previous.text?.should be_true
      $document["spec-2"].previous.previous.id.should == 'spec-1'
    end

    it 'should return nil when there is no previous sibling' do
      $document["spec-1"].previous.text?.should be_true
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
end
