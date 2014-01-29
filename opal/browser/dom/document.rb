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

  if Browser.supports? 'Document.view'
    def window
      Window.new(`#@native.defaultView`)
    end
  elsif Browser.supports? 'Document.window'
    def window
      Window.new(`#@native.parentWindow`)
    end
  else
    def window
      raise NotImplementedError, 'window from document unsupported'
    end
  end

  def create_text(content)
    DOM(`#@native.createTextNode(#{content})`)
  end

  def [](what)
    %x{
      var result = #@native.getElementById(what);

      if (result) {
        return #{DOM(`result`)};
      }
    }

    css(what).first || xpath(what).first
  end

  alias at []

  def document
    self
  end

  def inspect
    "#<DOM::Document: #{children.inspect}>"
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
    DOM(`#@native.getElementsByTagName("head")[0]`)
  end

  def body
    DOM(`#@native.body`)
  end

  def style_sheets
    Native::Array.new(`#@native.styleSheets`) {|e|
      CSS::StyleSheet.new(e)
    }
  end

  def root=(element)
    `#@native.documentElement = #{Native.convert(element)}`
  end
end

end; end
