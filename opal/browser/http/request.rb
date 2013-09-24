module Browser; module HTTP

class Request
  include Native::Base

  # Open and send a request.
  #
  # @param method [Symbol] the HTTP method to use
  # @param url [String, #to_s] the URL to request
  # @param parameters [String, Hash] the parameters to send
  #
  def self.open(method, url, parameters = nil, &block)
    request = new(&block)
    request.open(method, url)
    request.send(*parameters)
  end

  DEFAULT_HEADERS = Headers[{
    'X-Requested-With' => 'XMLHttpRequest',
    'X-Opal-Version'   => RUBY_ENGINE_VERSION,
    'Accept'           => 'text/javascript, text/html, application/xml, text/xml, */*'
  }]

  # @!attribute [r] headers
  # @return [Headers] the request headers
  attr_reader :headers

  # @!attribute [r] response
  # @return [Response] the response associated with this request
  attr_reader :response

  # @!attribute [r] method
  # @return [Symbol] the HTTP method for this request
  attr_reader :method

  # @!attribute [r] url
  # @return [String, #to_s] the URL for this request
  attr_reader :url

  # Create a request with the optionally given configuration block.
  #
  # @yield [request] if the block has a parameter the request is passed
  #                  otherwise it's instance_exec'd
  def initialize(&block)
    super(`new XMLHttpRequest()`)

    @headers      = Headers[DEFAULT_HEADERS]
    @method       = :get
    @asynchronous = true
    @binary       = false
    @cacheable     = true
    @opened       = false
    @sent         = false
    @completed    = false
    @callbacks    = {}

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end if block
  end

  # Check if the request has been opened.
  def opened?
    @opened
  end

  # Check if the request has been sent.
  def sent?
    @sent
  end

  # Check if the request has completed.
  def completed?
    @completed
  end

  # Check the request is asynchronous.
  def asynchronous?
    @asynchronous
  end

  # Check the request is synchronous.
  def synchronous?
    !@asynchronous
  end

  # Make the request asynchronous.
  #
  # @return [self]
  def asynchronous!
    @asynchronous = true

    self
  end

  # Make the request synchronous.
  #
  # @return [self]
  def synchronous!
    @asynchronous = false

    self
  end

  # Check the request is binary.
  def binary?
    @binary
  end

  # Make the request binary.
  def binary!
    @binary = true

    self
  end

  # Check if the request is cacheable.
  def cacheable?
    @cacheable
  end

  # Disable caching for this request.
  #
  # @return [self]
  def no_cache!
    @cacheable = false

    self
  end

  # Get or set the user used for authentication.
  #
  # @param value [String] when passed it sets, when omitted it gets
  #
  # @return [String]
  def user(value = nil)
    value ? @user = value : @user
  end

  # Get or set the password used for authentication.
  #
  # @param value [String] when passed it sets, when omitted it gets
  #
  # @return [String]
  def password(value = nil)
    value ? @password = value : @password
  end

  # Get or set the MIME type of the request.
  #
  # @param value [String] when passed it sets, when omitted it gets
  #
  # @return [String]
  def mime_type(value = nil)
    value ? @mime_type = value : @mime_type
  end

  # Get or set the Content-Type of the request.
  #
  # @param value [String] when passed it sets, when omitted it gets
  #
  # @return [String]
  def content_type(value = nil)
    value ? @content_type = value : @content_type
  end

  # Get or set the encoding of the request.
  #
  # @param value [String] when passed it sets, when omitted it gets
  #
  # @return [String]
  def encoding(value = nil)
    value ? @encoding = value : @encoding
  end

  # Set the request parameters.
  #
  # @param hash [Hash] the parameters
  #
  # @return [self]
  def parameters(hash)
    @parameters = hash

    self
  end

  # Register an event on the request.
  #
  # @param what [Symbol, String] the event name
  # @yield [response] yields the {Response}
  #
  # @return [self]
  def on(what, &block)
    @callbacks[what] = block

    self
  end

  # Open the request.
  #
  # @param method [Symbol] the HTTP method to use
  # @param url [String, #to_s] the URL to send the request to
  # @param asynchronous [Boolean] whether the request is asynchronous or not
  # @param user [String] the user to use for authentication
  # @param password [String] the password to use for authentication
  #
  # @return [Response] the response
  def open(method = nil, url = nil, asynchronous = nil, user = nil, password = nil)
    raise 'the request has already been opened' if opened?

    @method       = method       unless method.nil?
    @url          = url          unless url.nil?
    @asynchronous = asynchronous unless asynchronous.nil?
    @user         = user         unless user.nil?
    @password     = password     unless password.nil?

    url = @url

    unless cacheable?
      url += (url.include?(??) ? ?& : ??) + "_=#{rand}"
    end

    `#@native.open(#{@method.to_s.upcase}, #{url.to_s}, #{@asynchronous}, #{@user.to_n}, #{@password.to_n})`

    @opened = true

    unless @callbacks.empty?
      `#@native.onreadystatechange = #{callback}`
    end

    self
  end

  # Send the request with optional parameters.
  #
  # @param parameters [String, Hash] the data to send
  #
  # @return [Response] the response
  def send(parameters = @parameters)
    raise 'the request has not been opened' unless opened?

    raise 'the request has already been sent' if sent?

    unless cacheable?
      `#@native.setRequestHeader("If-Modified-Since", "Tue, 11 Sep 2001 12:46:00 GMT")`
    end

    @headers.each {|name, value|
      `#@native.setRequestHeader(#{name.to_s}, #{value.to_s})`
    }

    if @content_type
      header  = @content_type
      header += "; charset=#{@encoding}" if @encoding

      `#@native.setRequestHeader('Content-Type', header)`
    end

    if binary?
      if Buffer.supported?
        `#@native.responseType = 'arraybuffer'`
      else
        `#@native.overrideMimeType('text/plain; charset=x-user-defined')`
      end
    end

    if mime_type && !binary?
      `#@native.overrideMimeType(#@mime_type)`
    end

    @sent     = true
    @response = Response.new(self)

    if String === parameters
      data = parameters
    elsif Hash === parameters
      data = parameters.map {|vals|
        vals.map(&:encode_uri_component).join(?=)
      }.join(?&)

      unless @content_type
        `#@native.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')`
      end
    else
      data = `null`
    end

    `#@native.send(#{data})`

    @response
  end

  # Abort the request.
  #
  # @return [self]
  def abort
    `#@native.abort()`

    self
  end

private
  def callback
    proc {|event|
      state = %w[uninitialized loading loaded interactive complete][`#@native.readyState`]

      @callbacks[state].(response) if @callbacks[state]

      if state == :complete
        @completed = true
        @callbacks[response.status.code].(response) if @callbacks[response.status.code]

        if response.success?
          @callbacks[:success].(response) if @callbacks[:success]
        else
          @callbacks[:failure].(response) if @callbacks[:failure]
        end
      end
    }.to_n
  end
end

end; end
