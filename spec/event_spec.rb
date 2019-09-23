require 'spec_helper'
require 'browser/event'

describe Browser::Event do
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

    it "passes an event to the handler" do
      elem = $document["event-spec"]

      promise = Promise.new

      elem.on :click do |event|
        expect(event).to be_a(Browser::Event)
        promise.resolve
      end

      elem.trigger :click

      promise
    end

    it "passes additional arguments to the handler" do
      elem = $document["event-spec"]

      promise = Promise.new

      elem.on :bazinga do |event, foo, bar, baz|
        expect(foo).to eq(1)
        expect(bar).to eq(2)
        expect(baz).to eq(3)
        promise.resolve
      end

      elem.trigger :bazinga, 1, 2, 3

      promise
    end

    it "works with delegated events" do
      elem = $document["event-spec"]

      promise = Promise.new

      elem.on :bazinga, 'span.nami' do
        expect(true).to be_truthy
        promise.resolve
      end

      elem.add_child DOM { span.nami }

      after 0.01 do
        elem.first_element_child.trigger :bazinga
      end

      promise
    end
  end

  describe "#one" do
    it "fires once, passes arguments, works with custom events" do
      count = 0
      elem  = $document["event-spec"]

      elem.one :testone do |event, a, b, c|
        count += a + b*c
      end

      expect(count).to eq(0)
      elem.trigger :testone, 1, 2, 3
      expect(count).to eq(7)
      elem.trigger :testone, 2, 3, 4
      expect(count).to eq(7)
      elem.trigger :testone, 3, 4, 5
      expect(count).to eq(7)
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
