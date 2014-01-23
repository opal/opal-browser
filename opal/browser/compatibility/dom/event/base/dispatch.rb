module Browser; module DOM; class Event; module Target

if C.fire_event?
  def dispatch(event)
    `#@native.fireEvent("on" + #{event.name}, #{event.to_n})`
  end
else
  def dispatch(*)
    raise NotImplementedError
  end
end unless C.dispatch_event?

end; end; end; end
