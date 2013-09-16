module Browser; module CSS; class Rule

class Style < Rule
  alias_native :selector, :selectorText

  def declaration
    Declaration.new(`#@native.style`)
  end
end

end; end; end
