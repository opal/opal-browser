require 'spec_helper'

describe Browser::DOM::Element do
  describe '#id' do
    html <<-HTML
      <div id="lol"></div>
    HTML

    it 'gets the proper id' do
      $document["lol"].id.should == 'lol'
    end
  end

  describe '#class_names' do
    html <<-HTML
      <div id="class-names">
        <div id="class-names-1" class="a b c"></div>
        <div id="class-names-2" class=""></div>
      </div>
    HTML

    it 'gives an empty array when no class is set' do
      $document["class-names-2"].class_names.should == []
    end

    it 'gives an array of class names' do
      $document["class-names-1"].class_names.should == %w[a b c]
    end
  end

  describe '#matches?' do
    html <<-HTML
      <div id="matches" class="not me">
        <span class="yes me"></span>
      </div>
    HTML

    it 'matches on class and id' do
      $document[:matches].matches?('#matches.not.me').should be_truthy
    end

    it 'matches on class and name' do
      $document[:matches].first_element_child.matches?('span.yes').should be_truthy
    end
  end
end
