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
end
