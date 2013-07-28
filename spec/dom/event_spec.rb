require 'spec_helper'

describe Browser::DOM::Event do
  html <<-HTML
    <div id="event-spec">
      u wot m8
    </div>
  HTML

  describe "#on" do
    it "properly registers an event" do
      count = 0
      elem  = $document["event-spec"]

      elem.on :click do |event|
        count += 1
      end

      count.should == 0
      elem.trigger :click
      count.should == 1
      elem.trigger :click
      count.should == 2
      elem.trigger 'mouse:down'
      count.should == 2
    end
  end
end
