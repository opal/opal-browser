module Browser; module DOM

class Builder < BasicObject
  class Element < BasicObject
    def self.new(builder, element)
      return super unless self == Element

      name = element.name.capitalize

      if const_defined?(name)
        const_get(name).new(builder, element)
      else
        super
      end
    end

    def initialize(builder, element)
      @builder = builder
      @element = element
    end

    def style(*args, &block)
      @element.style(*args, &block)

      self
    end

    def on(*args, &block)
      @element.on(*args, &block)

      self
    end

    def text(text)
      @element << text.to_s

      self
    end

    def method_missing(name, content = nil, &block)
      if content
        @element << @builder.create_text!(content)
      end

      if name.end_with? ?!
        @element[:id] = name[0 .. -2]
      else
        @last = name
        @element.add_class name
      end

      @builder.extend!(@element, &block) if block

      self
    end

    def [](*names)
      return unless @last

      @element.remove_class @last
      @element.add_class [@last, *names].join('-')

      self
    end

    def do(&block)
      @builder.extend!(@element, &block)

      self
    end

    class Input < self
      { type:         :type,
        name:         :name,
        value:        :value,
        size:         :size,
        place_holder: :placeholder,
        read_only:    :readonly,
        required:     :required
      }.each {|name, attribute|
        define_method name do |value|
          @element[attribute] = value

          self
        end
      }
    end

    class A < self
      def href(value)
        @element[:href] = value

        self
      end

      def target(value)
        @element[:target] = value

        self
      end
    end
  end

  def initialize(document, element = nil, &block)
    Kernel.raise ArgumentError, "no block given" unless block

    @document = document
    @current  = element
    @roots    = ::Browser::DOM::NodeSet.new

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end
  end

  def root!
    @roots.first
  end

  def roots!
    @roots
  end

  def element!
    @current
  end

  alias el! element!

  def namespace!(name, &block)
    @namespace = name

    extend!(&block)
  end

  def extend!(element = nil, &block)
    old, @current = @current, element
    block.call(self)
    @current = old

    self
  end

  def <<(what)
    if what.is_a?(String)
      @current << create_text!(what)
    else
      @current << what
    end
  end

  def method_missing(name, *args, &block)
    if args.first.is_a?(String)
      content = args.shift
    end

    attributes = args.shift || {}

    if block
      parent  = @current
      element = create_element!(name, attributes)

      if content
        element << create_text!(content)
      end

      @current = element
      result   = block.call(self)
      @current = parent

      if String === result
        element.inner_html = result
      end

      (parent || @roots) << element
    else
      element  = create_element!(name, attributes)
      element << create_text!(content) if content

      (@current || @roots) << element
    end

    Element.new(self, element)
  end

private
  def create_element!(name, attributes)
    @document.create_element(name, namespace: @namespace).tap {|el|
      el.attributes.merge!(attributes)
    }
  end

  def create_text!(content)
    @document.create_text(content)
  end
end

end; end
