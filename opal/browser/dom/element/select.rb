# backtick_javascript: true

module Browser; module DOM; class Element < Node

class Select < Element
  def_selector "select"

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

  alias_native :value=

  def labels
    NodeSet[Native::Array.new(`#@native.labels`)]
  end

  def options
    NodeSet[Native::Array.new(`#@native.options`)]
  end

  def option
    DOM(`#@native.options[#@native.selectedIndex]`)
  end

  alias_native :index, :selectedIndex
  alias_native :multiple?, :multiple
  alias_native :required?, :required
  alias_native :length
end

end; end; end
