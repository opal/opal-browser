module Browser; module HTTP

class Request < Native
  def self.open(method, url, &block)
    request = new(&block)

    request.open(method, url)
    request.send
  end

  DefaultHeaders = Headers[{
    'X-Requested-With' => 'XMLHttpRequest',
    'X-Opal-Version'   => RUBY_ENGINE_VERSION,
    'Accept'           => 'text/javascript, text/html, application/xml, text/xml, */*'
  }]

  attr_reader   :data, :headers, :response
  attr_accessor :method, :url, :asynchronous, :user, :password, :mime_type, :content_type, :encoding

  def initialize(&block)
    super(`new XMLHttpRequest()`)

    @headers      = Headers[DefaultHeaders]
    @method       = :get
    @asynchronous = true
    @binary       = false
    @cachable     = true
    @opened       = false
    @sent         = false
    @completed    = false
    @callbacks    = {}

    instance_eval(&block)
  end

  def asynchronous?; @asynchronous;  end
  def synchronous?; !@asynchronous; end

  def asynchronous!; @asynchronous = true;  end
  def synchronous!;  @asynchronous = false; end

  def binary?; @binary;        end
  def binary!; @binary = true; end

  def cachable?; @cachable;         end
  def no_cache!; @cachable = false; end

  def opened?; @opened;        end
  def opened!; @opened = true; end

  def sent?; @sent;        end
  def sent!; @sent = true; end

  def completed?; @completed;        end
  def completed!; @completed = true; end

  def on(what, &block)
    @callbacks[what] = block
  end

  def callback
    proc {|event|
      state = %w[uninitialized loading loaded interactive complete][`#@native.readyState`]

      begin
        if state == :complete
          completed!

          @callbacks[response.status.code].(response) if @callbacks[response.status.code]

          if response.success?
            @callbacks[:success].(response) if @callbacks[:success]
          else
            @callbacks[:failure].(response) if @callbacks[:failure]
          end
        end

        @callbacks[state].(response) if @callbacks[state]
      rescue Exception => e
        @callbacks[:exception].(request, state, e) if @callbacks[:exception]
      end
    }.to_n
  end

  def open(method = nil, url = nil, asynchronous = nil, user = nil, password = nil)
    raise 'the request has already been opened' if opened?

    @method       = method       if method
    @url          = url          if url
    @asynchronous = asynchronous if asynchronous
    @user         = user         if user
    @password     = password     if password

    url = @url

    unless cachable?
      url += (url.include?('?') ? '&' : '?') + rand.to_s
    end

    `#@native.open(#{@method.upcase}, #{url}, #{@asynchronous.to_n}, #{@user.to_n}, #{@password.to_n})`

    opened!

    unless @callbacks.empty?
      `#@native.onreadystatechange = #{callback}`
    end

    self
  end

  def send(data = nil)
    raise 'the request has not been opened' unless opened?

    raise 'the request has already been sent' if sent?

    @headers.each {|name, value|
      `#@native.setRequestHeader(#{name.to_s}, #{value.to_s})`
    }

    if content_type
      header  = content_type
      header += "; charset=#{encoding}" if encoding

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

    sent!

    @response = Response.new(self)

    data_arg = data || @parameters ? Parameters[data || @parameters].to_str : `null`
    `#@native.send(#{data_arg})`
  end

  def abort
    `#@native.abort()`
  end
end

end; end
