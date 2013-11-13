require 'json'

module Browser; module HTTP

# Represents an HTTP response.
class Response
  include Native

  Status = Struct.new(:code, :text)

  # @!attribute [r] request
  # @return [Request] the request to this response
  attr_reader :request

  # Create a response from a request.
  #
  # @param request [Request] the request
  def initialize(request)
    super(request.to_n)

    @request = request
  end

  # @!attribute [r] headers
  # @return [Headers] the response headers
  def headers
    @headers ||= Headers.parse(`#@native.getAllResponseHeaders()`)
  end

  # @!attribute [r] status
  # @return [Status] the response status
  def status
    Status.new(`#@native.status || nil`, `#@native.statusText || nil`)
  end

  # Checks if the response was successful
  def success?
    if code = status.code
      code >= 200 && code < 300 || code == 304
    else
      false
    end
  end

  # Check if the response failed
  def failure?
    !success?
  end

  # @!attribute [r] text
  # @return [String] the response body as text
  def text
    %x{
      var result = #@native.responseText;

      if (!result) {
        return nil;
      }

      return result;
    }
  end

  # @!attribute [r] json
  # @return [Hash, Array] the response body as JSON
  def json
    %x{
      var result = #@native.responseText;

      if (!result) {
        return nil;
      }

      return #{JSON.parse(`result`)};
    }
  end

  # @!attribute [r] xml
  # @return [DOM::Document] the response body as DOM document
  def xml
    %x{
      var result = #@native.responseXML;

      if (!result) {
        return nil;
      }
    }

    DOM(`result`)
  end

  # @!attribute [r] binary
  # @return [Binary] the response body as binary
  def binary
    return unless request.binary?

    if Buffer.supported?
      %x{
        var result = #@native.response;

        if (!result) {
          return nil;
        }
      }

      Binary.new(Buffer.new(`result`))
    else
      return unless text

      Binary.new(text)
    end
  end
end

end; end
