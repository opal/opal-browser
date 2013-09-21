module Browser; module CSS; class Rule

class Style < Rule
  alias_native :selector, :selectorText
  alias_native :id, :selectorText

  # FIXME: when ^ is fixed remove these
  def selector
    `#@native.selectorText`
  end
  alias id selector
  # FIXME: ^

  def declaration
    Declaration.new(`#@native.style`)
  end

  def method_missing(*args, &block)
    declaration.__send__(*args, &block)
  end
end

end; end; end
