module Browser; module DOM; class Event; module Target

if C.fire_event?
  def dispatch(event)
    `#@native.fireEvent("on" + #{event.name}, #{event.to_n})`
  end
end

end; end; end; end
