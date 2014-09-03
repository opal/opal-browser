module Browser; module DOM

class Document < Element
  # Get the first element matching the given ID, CSS selector or XPath.
  #
  # @param what [String] ID, CSS selector or XPath
  #
  # @return [Element?] the first matching element
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

  # @!attribute [r] body
  # @return [Element?] the body element of the document
  def body
    DOM(`#@native.body`)
  end

  # Create a new element for the document.
  #
  # @param name [String] the node name
  # @param options [Hash] optional `:namespace` name
  #
  # @return [Element]
  def create_element(name, options = {})
    if ns = options[:namespace]
      DOM(`#@native.createElementNS(#{ns}, #{name})`)
    else
      DOM(`#@native.createElement(name)`)
    end
  end

  # Create a new text node for the document.
  #
  # @param content [String] the text content
  #
  # @return [Text]
  def create_text(content)
    DOM(`#@native.createTextNode(#{content})`)
  end

  def document
    self
  end

  # @!attribute [r] head
  # @return [Element?] the head element of the document
  def head
    DOM(`#@native.getElementsByTagName("head")[0]`)
  end

  def inspect
    "#<DOM::Document>"
  end

  if Browser.supports? 'Event.addListener'
    def ready(&block)
      raise ArgumentError, 'no block given' unless block

      return block.call if ready?

      on 'dom:load' do |e|
        e.off

        block.call
      end
    end
  elsif Browser.supports? 'Event.attach'
    def ready(&block)
      raise ArgumentError, 'no block given' unless block

      return block.call if ready?

      on 'ready:state:change' do |e|
        if ready?
          e.off

          block.call
        end
      end
    end
  else
    # Wait for the document to be ready and call the block.
    def ready(&block)
      raise NotImplementedError, 'document ready unsupported'
    end
  end

  # Check if the document is ready.
  def ready?
    `#@native.readyState === "complete"`
  end

  # @!attribute root
  # @return [Element?] the root element of the document
  def root
    DOM(`#@native.documentElement`)
  end

  def root=(element)
    `#@native.documentElement = #{Native.convert(element)}`
  end

  # @!attribute [r] style_sheets
  # @return [Array<CSS::StyleSheet>] the style sheets for the document
  def style_sheets
    Native::Array.new(`#@native.styleSheets`) {|e|
      CSS::StyleSheet.new(e)
    }
  end

  # @!attribute title
  # @return [String] the document title
  def title
    `#@native.title`
  end

  def title=(value)
    `#@native.title = value`
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
    # @!attribute [r] window
    # @return [Window] the window for the document
    def window
      raise NotImplementedError, 'window from document unsupported'
    end
  end
end

end; end
