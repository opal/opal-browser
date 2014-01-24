module Browser; module DOM; class Event; module Target

if Browser.supports? :event, :dispatch
  def dispatch(event)
    `#@native.dispatchEvent(#{event.to_n})`
  end
elsif Browser.supports? :event, :fire
  def dispatch(event)
    if Custom === event
      `#@native.fireEvent("ondataavailable", #{event.to_n})`
    else
      `#@native.fireEvent("on" + #{event.name}, #{event.to_n})`
    end
  end
else
  # @todo implement polyfill
  def dispatch(*)
    raise NotImplementedError
  end
end

end; end; end; end
