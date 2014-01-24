module Browser; module DOM; class Event; module Target

if Browser.supports? :event, :addListener
  def attach(callback)
    `#@native.addEventListener(#{callback.name}, #{callback.to_n})`

    callback
  end

  def attach!(callback)
    `#@native.addEventListener(#{callback.name}, #{callback.to_n}, true)`

    callback
  end
elsif Browser.supports? :event, :attach
  def attach(callback)
    `#@native.attachEvent("on" + #{callback.name}, #{callback.to_n})`
  end

  def attach!(callback)
    case callback.name
    when :blur
      `#@native.attachEvent("onfocusout", #{callback.to_n})`

    when :focus
      `#@native.attachEvent("onfocusin", #{callback.to_n})`

    else
      warn "attach: capture doesn't work on this browser"

      `#@native.attachEvent("on" + #{callback.name}, #{callback.to_n})`
    end
  end
else
  # @todo implement polyfill
  def attach(*)
    raise NotImplementedError
  end

  # @todo implement polyfill
  def attach!(*)
    raise NotImplementedError
  end
end

end; end; end; end
