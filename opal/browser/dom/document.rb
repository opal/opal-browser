require 'browser/location'

module Browser; module DOM

class Document < Node
  def [](what)
    %x{
      var result = #@native.getElementById(what);

      if (result) {
        return #{DOM(`result`)};
      }
    }

    xpath(what).first || css(what).first
  end

  alias at []

  def cookies
    Cookies.new(to_native) #if defined? `#@native.cookie`
  end

  def document
    self
  end

  def inspect
    "#<DOM::Document: #{children.inspect}>"
  end

  def location
    Location.new(`#@native.location`) if `#@native.location`
  end

  def root
    DOM(`#@native.documentElement`)
  end

  def root=(element)
    `#@native.documentElement = #{element.to_native}`
  end
end

end; end
