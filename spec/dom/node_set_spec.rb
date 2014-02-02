require 'spec_helper'

describe Browser::DOM::NodeSet do
  NodeSet = Browser::DOM::NodeSet

  html <<-HTML
    <div id="lol">
      <div class="a">
        <div class="a-a"></div>
      </div>

      <div class="b"></div>
      <div class="c"></div>

      <div class="d">
        <div class="d-a"></div>
      </div>
    </div>
  HTML

  describe '.[]' do
    it 'flattens the nodes' do
      set = NodeSet[[[$document["#lol .a"]]], [[$document["#lol .c"]]]]

      expect(set[0]).to eq($document["#lol .a"])
      expect(set[1]).to eq($document["#lol .c"])
    end

    it 'converts the items to DOM' do
      set = NodeSet[`document.getElementById("lol")`]

      expect(set[0]).to eq($document["#lol"])
    end
  end

  describe '#filter' do
    it 'filters the set with the given expression' do
      set = $document["lol"].children.filter('.a, .c')

      expect(set[0]).to eq($document["#lol .a"])
      expect(set[1]).to eq($document["#lol .c"])
    end
  end
end
