module Browser; module DOM; class Event; module Target

if C.detach_event?
  def detach(callback)
    `#@native.detachEvent("on" + #{callback.name}, #{callback.to_n})`
  end
else
  def detach(*)
    raise NotImplementedError
  end
end unless C.remove_event_listener?

end; end; end; end
