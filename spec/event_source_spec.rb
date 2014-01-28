require 'spec_helper'
require 'browser/event_source'

describe Browser::EventSource do
  async 'creates it' do
    Browser::EventSource.new '/events' do |es|
      es.on :open do |e|
        es.close

        async {
          expect(e.target).to be_a(Browser::EventSource)
        }
      end
    end
  end

  async 'receives an unnamed event' do
    Browser::EventSource.new '/events' do |es|
      es.on :message do |e|
        e.off
        es.close

        async {
          expect(e.data).to eq('lol')
        }
      end
    end
  end

  async 'receives a named event' do
    Browser::EventSource.new '/events' do |es|
      es.on :custom do |e|
        e.off
        es.close

        async {
          expect(e.data).to eq('omg')
        }
      end
    end
  end
end if Browser::EventSource.supported?
