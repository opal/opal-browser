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

    it "listens for custom events" do
      count = 0
      elem  = $document["event-spec"]

      elem.on :huehue do
        count += 1
      end

      count.should == 0
      elem.trigger :huehue
      count.should == 1
      elem.trigger :huehue
      count.should == 2
    end

    async "passes an event to the handler" do
      elem = $document["event-spec"]

      elem.on :click do |event|
        run_async {
          event.should be_kind_of Browser::DOM::Event
        }
      end

      elem.trigger :click
    end

    async "passes additional arguments to the handler" do
      elem = $document["event-spec"]

      elem.on :bazinga do |event, foo, bar, baz|
        run_async {
          foo.should == 1
          bar.should == 2
          baz.should == 3
        }
      end

      elem.trigger :bazinga, 1, 2, 3
    end

    async "works with deferred elements" do
      elem = $document["event-spec"]

      elem.on :bazinga, 'span.nami' do
        run_async {
          true.should be_truthy
        }
      end

      elem.add_child DOM { span.nami }

      after 0.01 do
        elem.first_element_child.trigger :bazinga
      end
    end
  end

  describe "#off" do
    it "removes all the handlers that were added" do
      count = 0
      elem  = $document["event-spec"]

      elem.on :click do
        count += 1
      end

      elem.on :click do
        count += 1
      end

      elem.trigger :click
      count.should == 2

      elem.off :click
      elem.trigger :click
      count.should == 2
    end

    it "removes only the passed handler" do
      count = 0
      elem  = $document["event-spec"]

      cb = elem.on :click do
        count += 1
      end

      elem.on :click do
        count += 1
      end

      elem.trigger :click
      count.should == 2

      cb.off
      elem.trigger :click
      count.should == 3
    end
  end
end
