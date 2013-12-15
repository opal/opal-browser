module Paggio::Utils
  def self.heredoc(string)
    string
  end
end

class Paggio::HTML::Element < BasicObject
  def on(*args, &block)
    (@on ||= []) << [args, block]
  end

  def style(*args, &block)
    @style = [args, block]
  end
end

module Browser; module DOM

class Builder
  HTML = Paggio::HTML

  def initialize(document, element = nil, &block)
    @document = document
    @element  = element
    @builder  = Paggio::HTML.new(&block)
    @roots    = @builder.each.map { |e| convert(e) }

    if @element
      @roots.each {|root|
        @element << root
      }
    end
  end

  def to_a
    @roots
  end

private
  def convert(element)
    case element
    when String
      create_text(element)

    when HTML::Element
      name, attributes, class_names = element.instance_eval {
        [@name, @attributes, @class_names]
      }

      dom = create_element(name, attributes)

      class_names.each {|value|
        dom.add_class value
      }

      if on = element.instance_eval { @on }
        on.each {|args, block|
          dom.on(*args, &block)
        }
      end

      if style = element.instance_eval { @style }
        dom.style(*style[0], &style[1])
      end

      if inner = element.instance_eval { @inner_html }
        dom.inner_html = inner
      else
        element.each {|child|
          dom << convert(child)
        }
      end

      dom
    end
  end

  def create_element(name, attributes = {}, namespace = nil)
    element = @document.create_element(name, namespace: namespace)
    element.attributes.merge!(attributes)

    element
  end

  def create_text(content)
    @document.create_text(content)
  end
end

end; end
