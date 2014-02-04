require 'spec_helper'

describe Browser::DOM::Element::Attributes do
  html <<-HTML
    <label id="lol" class="name" for="hue"></label>
  HTML

  describe '#[]' do
    it 'gets an attribute' do
      expect($document[:lol].attributes[:id]).to eq(:lol)
    end

    it 'gets the class attribute' do
      expect($document[:lol].attributes[:class]).to eq(:name)
    end

    it 'gets the for attribute' do
      expect($document[:lol].attributes[:for]).to eq(:hue)
    end
  end

  describe '#[]=' do
    it 'sets an attribute' do
      $document[:lol].attributes[:a] = :foo

      expect($document[:lol].attributes[:a]).to eq(:foo)
    end

    it 'sets the class attribute' do
      $document[:lol].attributes[:class] = :bar

      expect($document[:lol].attributes[:class]).to eq(:bar)
    end

    it 'sets the for attribute' do
      $document[:lol].attributes[:for] = :baz

      expect($document[:lol].attributes[:for]).to eq(:baz)
    end
  end

  describe '#each' do
    it 'enumerates over the attributes' do
      attributes = $document[:lol].attributes.select {|name, _|
        %w[class for id].include?(name)
      }

      expect(attributes.sort).to eq \
        [[:class, :name], [:for, :hue], [:id, :lol]]
    end
  end
end
