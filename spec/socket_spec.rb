require 'spec_helper'
require 'browser/location'
require 'browser/socket'

describe Browser::Socket do
  # FIXME: find out why it doesn't work inline
  ws = "ws://#{$window.location.host}/socket"

  it 'creates a socket' do
    promise = Promise.new
    Browser::Socket.new ws do |s|
      s.on :open do |e|
        expect(e.target).to be_a(Browser::Socket)
        promise.resolve
      end
    end
    promise
  end

  it 'receives messages' do
    promise = Promise.new
    Browser::Socket.new ws do |s|
      s.on :message do |e|
        expect(e.data).to eq('lol')
        promise.resolve
      end
    end
    promise
  end

  it 'sends messages' do
    promise = Promise.new
    Browser::Socket.new ws do |s|
      s.on :message do |e|
        e.off

        s.print 'omg'

        s.on :message do |e|
          expect(e.data).to eq('omg')
          promise.resolve
        end
      end
    end
    promise
  end
end if Browser::Socket.supported?
