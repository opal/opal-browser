module Browser; module HTTP

class Request
  include Native::Base

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

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end if block
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

  def parameters(hash)
    @parameters = hash
  end

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

    @method       = method       unless method.nil?
    @url          = url          unless url.nil?
    @asynchronous = asynchronous unless asynchronous.nil?
    @user         = user         unless user.nil?
    @password     = password     unless password.nil?

    url = @url

    unless cachable?
      url += (url.include?('?') ? '&' : '?') + rand.to_s
    end

    `#@native.open(#{@method.to_s.upcase}, #{url.to_s}, #{@asynchronous}, #{@user.to_n}, #{@password.to_n})`

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

    if data.nil?
      data = `null`
    elsif data.is_a?(Hash) || @parameters
      data = (data || @parameters).map {|vals|
        vals.map(&:encode_uri_component).join('=')
      }.join('&')

      unless content_type
        `#@native.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')`
      end
    end

    `#@native.send(#{data})`

    @response
  end

  def abort
    `#@native.abort()`
  end
end

end; end
