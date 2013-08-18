#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module Browser

class Socket
  include Native::Base
  include IO::Writable
  include DOM::Event::Target

  target {|value|
    Socket.new(value) if `window.WebSocket && #{value} instanceof window.WebSocket`
  }

  def initialize(url, protocol = nil, &block)
    if native?(url)
      super(url)
    else
      super(`new window.WebSocket(#{url.to_s}, #{protocol.to_n})`)
    end

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end if block
  end

  alias_native :protocol, :protocol
  alias_native :url, :url
  alias_native :buffered, :bufferedAmount

  def type
    %x{
      switch (#@native.binaryType) {
        case "blob":
          return "blob";

        case "arraybuffer":
          return "buffer";

        default:
          return "string";
      }
    }
  end

  def state
    %x{
      switch (#@native.readyState) {
        case window.WebSocket.CONNECTING:
          return "connecting";

        case window.WebSocket.OPEN:
          return "open";

        case window.WebSocket.CLOSING:
          return "closing";

        case window.WebSocket.CLOSED:
          return "closed";
      }
    }
  end

  def extensions
    %x{
      if (#@native.extensions == "") {
        return nil;
      }
      else {
        return #@native.extensions;
      }
    }
  end

  def alive?
    state == :open
  end

  def write(data)
    `#@native.send(#{data.to_n})`
  end

  def close(code = nil, reason = nil)
    `#@native.close(#{code.to_n}, #{reason.to_n})`
  end
end

end
