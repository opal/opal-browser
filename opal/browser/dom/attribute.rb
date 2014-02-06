module Browser; module DOM

# Encapsulates an {Element} attribute.
class Attribute
  include Native

  # @!attribute [r] name
  # @return [String] the name of the attribute
  alias_native :name

  # @!attribute value
  # @return [String] the value of the attribute
  alias_native :value
  alias_native :value=

  # Returns true if the attribute is an id.
  alias_native :id?, :isId
end

end; end
