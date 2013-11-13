module Browser; module DOM

class Attribute
  include Native

  def id?
    `#@native.isId`
  end

  def name
    `#@native.name`
  end

  def value
    `#@native.value`
  end
end

end; end
