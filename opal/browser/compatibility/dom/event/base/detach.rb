module Browser; module DOM; class Event; module Target

if Browser.supports? :event, :removeListener
  def detach(callback)
    `#@native.removeEventListener(#{callback.name}, #{callback.to_n}, false)`
  end
elsif Browser.supports? :event, :detach
  def detach(callback)
    `#@native.detachEvent("on" + #{callback.name}, #{callback.to_n})`
  end
else
  # @todo implement internal handler thing
  def detach(callback)
    raise NotImplementedError
  end
end

end; end; end; end
