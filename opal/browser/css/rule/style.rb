module Browser; module CSS; class Rule

class Style < Rule
  alias_native :selector, :selectorText

  def declaration
    Declaration.new(`#@native.style`)
  end

  def method_missing(*args, &block)
    declaration.__send__(*args, &block)
  end
end

end; end; end
