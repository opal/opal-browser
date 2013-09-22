module Browser

class Socket
  include Native::Base
  include IO::Writable
  include DOM::Event::Target

  target {|value|
    Socket.new(value) if `window.WebSocket && #{value} instanceof window.WebSocket`
  }

  # Create a connection to the given URL, optionally using the given protocol.
  #
  # @param url [String] URL to connect to
  # @param protocol [String] protocol to use
  # @yield if the block has no parameters it's instance_exec'd, otherwise it's
  #        called with self
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

  # The protocol of the socket.
  #
  # @return [String]
  alias_native :protocol

  # The URL the socket is connected to.
  #
  # @return [String]
  alias_native :url

  # The amount of buffered data.
  #
  # @return [Integer]
  alias_native :buffered, :bufferedAmount

  # The type of the socket.
  #
  # @return [:blob, :buffer, :string]
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

  # The state of the socket.
  #
  # @return [:connecting, :open, :closing, :closed]
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

  # The extensions used by the socket,
  #
  # @return [Array<String>]
  def extensions
    `#@native.extensions`.split(/\s*,\s*/)
  end

  # Check if the socket is alive.
  def alive?
    state == :open
  end

  # Send data to the socket.
  #
  # @param data [Object] the data to send
  def write(data)
    `#@native.send(#{data.to_n})`
  end

  # Close the socket.
  #
  # @param code [Integer, nil] the error code
  # @param reason [String, nil] the reason for closing
  def close(code = nil, reason = nil)
    `#@native.close(#{code.to_n}, #{reason.to_n})`
  end
end

end
