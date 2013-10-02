require 'spec_helper'
require 'browser/socket'

describe Browser::Socket do
  # FIXME: find out why it doesn't work inline
  ws = "ws://#{$window.location.host}/socket"

  async 'creates a socket' do
    Browser::Socket.new ws do |s|
      s.on :open do |e|
        run_async {
          e.target.should be_kind_of Browser::Socket
        }
      end
    end
  end

  async 'receives messages' do
    Browser::Socket.new ws do |s|
      s.on :message do |e|
        run_async {
          e.data.should == 'lol'
        }
      end
    end
  end

  async 'sends messages' do
    Browser::Socket.new ws do |s|
      s.on :message do |e|
        s.print 'omg'

        s.on :message do |e|
          run_async {
            e.data.should == 'omg'
          }
        end

        e.off
      end
    end
  end
end if Browser::Socket.supported?
