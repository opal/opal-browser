require 'spec_helper'
require 'browser/event_source'

describe Browser::EventSource do
  it 'creates it' do
    promise = Browser::Promise.new
    Browser::EventSource.new '/events' do |es|
      es.on :open do |e|
        es.close

        expect(e.target).to be_a(Browser::EventSource)
        promise.resolve
      end
    end
    promise.for_rspec
  end

  it 'receives an unnamed event' do
    promise = Browser::Promise.new
    Browser::EventSource.new '/events' do |es|
      es.on :message do |e|
        e.off
        es.close

        expect(e.data).to eq('lol')
        promise.resolve
      end
    end
    promise.for_rspec
  end

  it 'receives a named event' do
    promise = Browser::Promise.new
    Browser::EventSource.new '/events' do |es|
      es.on :custom do |e|
        e.off
        es.close

        expect(e.data).to eq('omg')
        promise.resolve
      end
    end
    promise.for_rspec
  end
end if Browser::EventSource.supported?
