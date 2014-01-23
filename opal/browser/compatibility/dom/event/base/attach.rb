module Browser; module DOM; class Event; module Target

if C.attach_event?
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
end

end; end; end; end
