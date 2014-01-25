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

      expect(count).to eq(0)
      elem.trigger :click
      expect(count).to eq(1)
      elem.trigger :click
      expect(count).to eq(2)
      elem.trigger 'mouse:down'
      expect(count).to eq(2)
    end

    it "listens for custom events" do
      count = 0
      elem  = $document["event-spec"]

      elem.on :huehue do
        count += 1
      end

      expect(count).to eq(0)
      elem.trigger :huehue
      expect(count).to eq(1)
      elem.trigger :huehue
      expect(count).to eq(2)
    end

    async "passes an event to the handler" do
      elem = $document["event-spec"]

      elem.on :click do |event|
        async {
          expect(event).to be_a(Browser::DOM::Event)
        }
      end

      elem.trigger :click
    end

    async "passes additional arguments to the handler" do
      elem = $document["event-spec"]

      elem.on :bazinga do |event, foo, bar, baz|
        async {
          expect(foo).to eq(1)
          expect(bar).to eq(2)
          expect(baz).to eq(3)
        }
      end

      elem.trigger :bazinga, 1, 2, 3
    end

    async "works with delegated events" do
      elem = $document["event-spec"]

      elem.on :bazinga, 'span.nami' do
        async {
          expect(true).to be_truthy
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
      expect(count).to eq(2)

      elem.off :click
      elem.trigger :click
      expect(count).to eq(2)
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
      expect(count).to eq(2)

      cb.off
      elem.trigger :click
      expect(count).to eq(3)
    end
  end
end
