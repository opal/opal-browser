# backtick_javascript: true
module Browser; module DOM

class Document < Element
  include DocumentOrShadowRoot

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
  rescue ArgumentError
    raise '$document.body is not defined; try to wrap your code in $document.ready{}'
  end

  # Create a new element for the document.
  #
  # @param name [String] the node name
  # @param builder [Browser::DOM::Builder] optional builder to append element to
  # @param options [String] :namespace optional namespace name
  # @param options [String] :is optional WebComponents is parameter
  # @param options [String] :id optional id to set
  # @param options [Array<String>] :classes optional classes to set
  # @param options [Hash] :attrs optional attributes to set
  #
  # @return [Element]
  def create_element(name, builder=nil, **options, &block)
    opts = {}

    if options[:is] ||= (options.dig(:attrs, :is))
      opts[:is] = options[:is]
    end

    if ns = options[:namespace]
      elem = `#@native.createElementNS(#{ns}, #{name}, #{opts.to_n})`
    else
      elem = `#@native.createElement(name, #{opts.to_n})`
    end

    if options[:classes]
      `#{elem}.className = #{Array(options[:classes]).join(" ")}`
    end

    if options[:id]
      `#{elem}.id = #{options[:id]}`
    end

    if options[:attrs]
      options[:attrs].each do |k,v|
        next unless v
        `#{elem}.setAttribute(#{k}, #{v})`
      end
    end

    dom = DOM(elem)

    if block_given?
      dom.inner_dom(builder, &block)
    end

    if builder
      builder << dom
    end

    dom
  end

  # Create a new document fragment.
  #
  # @return [DocumentFragment]
  def create_document_fragment
    DOM(`#@native.createDocumentFragment()`)
  end

  # Create a new text node for the document.
  #
  # @param content [String] the text content
  #
  # @return [Text]
  def create_text(content)
    DOM(`#@native.createTextNode(#{content})`)
  end

  # Create a new comment node for the document.
  #
  # @param content [String] the comment content
  #
  # @return [Comment]
  def create_comment(content)
    DOM(`#@native.createComment(#{content})`)
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
    `#@native.readyState === "complete" || #@native.readyState === "interactive"`
  end

  # @!attribute referrer
  # @return [String] the referring document, or empty string if direct access
  def referrer
    `#@native.referrer`
  end

  # @!attribute root
  # @return [Element?] the root element of the document
  def root
    DOM(`#@native.documentElement`)
  end

  def root=(element)
    `#@native.documentElement = #{Native.convert(element)}`
  end

  # @!attribute title
  # @return [String] the document title
  def title
    `#@native.title`
  end

  def title=(value)
    `#@native.title = value`
  end

  # @!attribute [r] hidden?
  # @return [Boolean] is the page considered hidden?
  def hidden?
    `#@native.hidden`
  end

  # @!attribute [r] visibility
  # @return [String] the visibility state of the document - prerender, hidden or visible
  def visibility
    `#@native.visibilityState`
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
