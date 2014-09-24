module Browser; module DOM; class Element < Node

class Select < Element
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

  def labels
    NodeSet[Native::Array.new(`#@native.labels`)]
  end

  def options
    NodeSet[Native::Array.new(`#@native.options`)]
  end

  def option
    DOM(`#@native.options[#@native.selectedIndex]`)
  end

  def index
    `#@native.selectedIndex`
  end

  alias_native :multiple?, :multiple
  alias_native :required?, :required
  alias_native :length
end

end; end; end
