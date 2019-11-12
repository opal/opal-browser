module Browser

# Implements (parts of) the web crypto interface
#
# https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API
class Crypto
  include NativeCachedWrapper

  class Digest
    def initialize(buf)
      @buffer = Buffer.new(buf)
    end

    attr_reader :buffer

    # Convert a digest to a hexadecimal string
    def to_hex
      buffer.to_a.map { |i| "%02x" % i }.join
    end

    # Convert a digest to a binary string
    def to_s
      buffer.to_a.map { |i| "%c" % i }.join
    end

    # Convert a digest to a Base64-encoded string
    #
    # You will need to `require "base64"`
    def to_b64
      Base64.strict_encode64(to_s)
    end

    # Convert a digest to a urlsafe Base64-encoded string
    #
    # You will need to `require "base64"`
    def to_u64(padding: false)
      Base64.urlsafe_encode64(to_s, padding: padding)
    end
  end

  # Compute a cryptographic digest of data (a Buffer). If block is given,
  # it will call a block, otherwise it will return a Promise that will
  # return once a digest is computed.
  #
  # Allowed values for algo: SHA-1, SHA-256 (default), SHA-368, SHA-512.
  #
  # The block/promise will be given an argument of type {Digest} which can
  # be used to format a digest.
  #
  # Example:
  # ```
  # Browser::Blob.new(['test']).buffer.then { |b|
  #   $window.crypto.digest(b)
  # }.then { |d|
  #   puts d.to_hex
  # }
  # ```
  def digest data, algo = 'SHA-256', &block
    promise = nil
    unless block_given?
      promise = Promise.new
      block = proc { |i| promise.resolve(i) }
    end
    resblock = proc { |i| block.call(Digest.new(i)) }

    `#@native.subtle.digest(algo, #{Native.convert(data)}).then(#{resblock.to_n})`
    promise
  end
end

class Window
  # @!attribute [r] crypto
  # @return [Crypto] the crypto interface of this window
  def crypto
    @crypto ||= Crypto.new(`#@native.crypto`)
  end
end

end
