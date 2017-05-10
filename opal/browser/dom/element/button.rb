module Browser; module DOM; class Element < Node

class Button < Element
  def disabled?
    `#@native.disabled`
  end

  def disabled=(value)
    `#@native.disabled = #{value}`
  end

  def autofocus?
    `#@native.autofocus`
  end

  def autofocus=(value)
    `#@native.autofocus = #{value}`
  end

  def name
    `#@native.name`
  end

  def name=(value)
    `#@native.name = #{value}`
  end
end

end; end; end
