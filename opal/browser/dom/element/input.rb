module Browser; module DOM; class Element < Node

class Input < Element
  def value
    `#@native.value`
  end

  def value=(value)
    `#@native.value = #{value}`
  end
end

end; end; end
