require 'spec_helper'

describe Browser::DOM::Attribute do
  html <<-HTML
    <div id="lol" class="hue" something="wat"></div>
  HTML

  describe '#name' do
    it 'gets the right name' do
      attr = $document['lol'].attribute_nodes.find { |a| a.name == :id }

      expect(attr.name).to eq(:id)
    end
  end

  describe '#value' do
    it 'gets the right value' do
      attr = $document['lol'].attribute_nodes.find { |a| a.name == :id }

      expect(attr.name).to eq(:id)
      expect(attr.value).to eq(:lol)
    end
  end

  describe '#value=' do
    it 'sets the value' do
      attr = $document['lol'].attribute_nodes.find { |a| a.name == :id }

      expect(attr.name).to eq(:id)
      expect(attr.value).to eq(:lol)
      attr.value = :omg
      expect(attr.value).to eq(:omg)
    end
  end

  describe '#id?' do
    it 'is true for an id attribute' do
      attr = $document['lol'].attribute_nodes.find { |a| a.name == :id }

      expect(attr.id?).to be_truthy
    end

    it 'is false for any other attribute' do
      attr = $document['lol'].attribute_nodes.find { |a| a.name == :class }

      expect(attr.id?).to be_falsy
    end
  end
end
