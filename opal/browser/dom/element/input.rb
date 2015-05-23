module Browser; module DOM; class Element < Node

class Input < Element
  def value
    %x{
      if (#@native.value == "") {
        return nil;
      }
      else {
        return #@native.value;
      }
    }
  end

  def value=(value)
    `#@native.value = #{value}`
  end

  def checked?
    `#@native.checked`
  end

  def clear
    `#@native.value = ''`
  end
end

end; end; end
