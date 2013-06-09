module Browser; module DOM; class Event

class Keyboard < Event
  def alt?
    `#@native.altKey`
  end

  def ctrl?
    `#@native.ctrlKey`
  end

  def meta?
    `#@native.metaKey`
  end

  def shift?
    `#@native.shiftKey`
  end

  def code
    `#@native.keyCode || #@native.which`
  end

  alias to_i code
end

end; end; end
