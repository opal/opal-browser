require 'spec_helper'
require 'browser/location'
require 'browser/socket'

describe Browser::Socket do
  # FIXME: find out why it doesn't work inline
  ws = "ws://#{$window.location.host}/socket"

  async 'creates a socket' do
    Browser::Socket.new ws do |s|
      s.on :open do |e|
        async {
          expect(e.target).to be_a(Browser::Socket)
        }
      end
    end
  end

  async 'receives messages' do
    Browser::Socket.new ws do |s|
      s.on :message do |e|
        async {
          expect(e.data).to eq('lol')
        }
      end
    end
  end

  async 'sends messages' do
    Browser::Socket.new ws do |s|
      s.on :message do |e|
        e.off

        s.print 'omg'

        s.on :message do |e|
          async {
            expect(e.data).to eq('omg')
          }
        end
      end
    end
  end
end if Browser::Socket.supported?
