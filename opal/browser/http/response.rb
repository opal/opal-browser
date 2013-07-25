require 'struct'
require 'json'

module Browser; module HTTP

class Response < Native
  Status = Struct.new(:code, :text)

  attr_reader :request

  def initialize(request)
    super(request.to_n)

    @request = request
  end

  def headers
    @headers ||= Headers.parse(`#@native.getAllResponseHeaders()`)
  end

  def status
    Status.new(`#@native.status || nil`, `#@native.statusText || nil`)
  end

  def success?
    if code = status.code
      code >= 200 && code < 300 || code == 304
    else
      false
    end
  end

  def failure?
    !success?
  end

  def text
    %x{
      var result = #@native.responseText;

      if (!result) {
        return nil;
      }

      return result;
    }
  end

  def json
    %x{
      var result = #@native.responseText;

      if (!result) {
        return nil;
      }

      return #{JSON.parse(`result`)};
    }
  end

  def xml
    %x{
      var result = #@native.responseXML;

      if (!result) {
        return nil;
      }
    }

    DOM(`result`)
  end

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
