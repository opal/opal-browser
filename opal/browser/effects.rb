module Browser; module DOM

class Document < Element
  def active_element
    DOM(`#@native.activeElement`)
  end
end

class Element
  def show(what = :block)
    style[:display] = what
  end

  def hide
    style[:display] = :none
  end

  def toggle
    if style![:display] == :none
      show
    else
      hide
    end
  end

  def focus
    `#@native.focus()`
  end

  def blur
    `#@native.blur()`
  end

  def focused?
    `#@native.hasFocus`
  end
end

end; end
