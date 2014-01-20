module Browser; module DOM

# Encapsulates an {Element} attribute.
class Attribute
  include Native

  # Returns true if the attribute is an id.
  def id?
    `#@native.isId`
  end

  # @!attribute [r] name
  # @return [String] the name of the attribute
  def name
    `#@native.name`
  end

  # @!attribute [r] value
  # @return [String] the value of the attribute
  def value
    `#@native.value`
  end
end

end; end
