require 'browser/location'

module Browser; module DOM

class Document < Element
  def create_element(name, options = {})
    if ns = options[:namespace]
      DOM(`#@native.createElementNS(#{ns}, #{name})`)
    else
      DOM(`#@native.createElement(name)`)
    end
  end

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

  def title
    `#@native.title`
  end

  def title=(value)
    `#@native.title = value`
  end

  def root
    DOM(`#@native.documentElement`)
  end

  def head
    xpath('//head').first
  end

  def body
    xpath('//body').first
  end

  def root=(element)
    `#@native.documentElement = #{element.to_native}`
  end

  def inspect
    "#<DOM::Document:#{object_id}>"
  end
end

end; end
