require 'spec_helper'

describe Browser::DOM::Element do
  describe '#id' do
    html <<-HTML
      <div id="lol"></div>
    HTML

    it 'gets the proper id' do
      expect($document["lol"].id).to eq('lol')
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
      expect($document["class-names-2"].class_names).to eq([])
    end

    it 'gives an array of class names' do
      expect($document["class-names-1"].class_names).to eq(%w[a b c])
    end
  end

  describe '#=~' do
    html <<-HTML
      <div id="matches" class="not me">
        <span class="yes me"></span>
      </div>
    HTML

    it 'matches on class and id' do
      expect($document[:matches] =~ '#matches.not.me').to be_truthy
    end

    it 'matches on class and name' do
      expect($document[:matches].first_element_child =~ 'span.yes').to be_truthy
    end
  end
end
