require 'spec_helper'
require 'browser/event_source'

describe Browser::EventSource do
  async 'creates it' do
    Browser::EventSource.new '/events' do |es|
      es.on :open do |e|
        run_async {
          e.target.should be_kind_of Browser::EventSource
        }

        es.close
      end
    end
  end

  async 'receives an unnamed event' do
    Browser::EventSource.new '/events' do |es|
      es.on :message do |e|
        run_async {
          e.data.should == 'lol'
        }

        e.off
        es.close
      end
    end
  end

  async 'receives a named event' do
    Browser::EventSource.new '/events' do |es|
      es.on :custom do |e|
        run_async {
          e.data.should == 'omg'
        }

        e.off
        es.close
      end
    end
  end
end if Browser::EventSource.supported?
