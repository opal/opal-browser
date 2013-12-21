# Temporary fix for a bug in String#scan
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
  def self.to_h
    @builders ||= {}
  end

  def self.for(klass, &block)
    if block
      to_h[klass] = block
    else
      to_h[klass]
    end
  end

  def self.build(builder, item)
    to_h.each {|klass, block|
      if klass === item
        break block.call(builder, item)
      end
    }
  end

  attr_reader :document, :element

  def initialize(document, element = nil, &block)
    @document = document
    @element  = element
    @builder  = Paggio::HTML.new(&block)
    @roots    = @builder.each.map { |e| Builder.build(self, e) }

    if @element
      @roots.each {|root|
        @element << root
      }
    end
  end

  def to_a
    @roots
  end
end

Builder.for String do |b, item|
  b.document.create_text(item)
end

Builder.for Paggio::HTML::Element do |b, item|
  dom = b.document.create_element(`item.name`)
  dom.attributes.merge!(`item.attributes || {}`)

  `item.class_names`.each {|value|
    dom.add_class value
  }

  if on = `item.on || nil`
    on.each {|args, block|
      dom.on(*args, &block)
    }
  end

  if style = `item.style || nil`
    dom.style(*style[0], &style[1])
  end

  if inner = `item.inner_html || nil`
    dom.inner_html = inner
  else
    item.each {|child|
      dom << Builder.build(b, child)
    }
  end

  dom
end

end; end
