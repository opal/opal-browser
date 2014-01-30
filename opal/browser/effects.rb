module Browser; module DOM

class Document < Element
  # @!attribute [r] active_element
  # @return [Element] the element with focus
  def active_element
    DOM(`#@native.activeElement`)
  end
end

class Element
  # Show the element.
  #
  # @param what [Symbol] how to display it
  def show(what = :block)
    style[:display] = what
  end

  # Hide the element.
  def hide
    style[:display] = :none
  end

  # Toggle the visibility of the element, hide it if it's shown, show it if
  # it's hidden.
  def toggle
    if style![:display] == :none
      show
    else
      hide
    end
  end

  # Set the focus on the element.
  def focus
    `#@native.focus()`
  end

  # Blur the focus from the element.
  def blur
    `#@native.blur()`
  end

  # Check if the element is focused.
  def focused?
    `#@native.hasFocus`
  end
end

end; end
