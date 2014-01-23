module Browser; module DOM; class Event; module Target

if C.detach_event?
  def detach(callback)
    `#@native.detachEvent("on" + #{callback.name}, #{callback.to_n})`
  end
end

end; end; end; end
