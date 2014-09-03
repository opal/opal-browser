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
        return block.call(builder, item)
      end
    }

    raise ArgumentError, "cannot build unknown item #{item}"
  end

  attr_reader :document, :element

  def initialize(document, &block)
    @document = document
    @builder  = Paggio::HTML.new(&block)
    @roots    = @builder.each.map { |e| Builder.build(self, e) }
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

  if Hash === `item.attributes`
    dom.attributes.merge!(`item.attributes`)
  end

  `item.class_names`.each {|value|
    dom.add_class value
  }

  if on = `item.on || nil`
    on.each {|args, block|
      dom.on(*args, &block)
    }
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

Builder.for DOM::Node do |b, item|
  item
end

end; end
