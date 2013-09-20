module Browser; module DOM

class MutationObserver
  include Native::Base

  class Record
    include Native::Base

    def type
      case `#@native.type`
      when :attributes    then :attributes
      when :childList     then :tree
      when :characterData then :cdata
      end
    end

    def attributes?; type == :attributes; end
    def tree?;       type == :tree;       end
    def cdata?;      type == :cdata;      end

    def added
      if `#@native.addedNodes != null`
        NodeSet.new($document, Native::Array.new(`#@native.addedNodes`))
      end
    end

    def removed
      if `#@native.removedNodes != null`
        NodeSet.new($document, Native::Array.new(`#@native.removedNodes`))
      end
    end

    def target
      DOM(`#@native.target`)
    end

    alias_native :old, :oldValue
    alias_native :attribute, :attributeName

    def old
      `#@native.oldValue || nil`
    end
  end

  def initialize(&block)
    %x{
      var func = function(records) {
        return #{block.call(`records`.map { |r| Browser::DOM::MutationObserver::Record.new(r) })};
      }
    }

    super(`new window.MutationObserver(func)`)
  end

  def observe(target, options = nil)
    unless options
      options = {
        children: true,
        tree: true,
        attributes: :old,
        cdata: :old
      }
    end

    `#@native.observe(#{Native.convert(target)}, #{convert(options)})`

    self
  end

  def take
    `#@native.takeRecords()`.map { |r| Record.new(r) }
  end

  def disconnect
    `#@native.disconnect()`
  end

private
  def convert(hash)
    options = Native(`{}`)

    if hash[:children]
      options[:childList] = true
    end

    if hash[:tree]
      options[:subtree] = true
    end

    if attrs = hash[:attributes]
      options[:attributes] = true

      if attrs == :old
        options[:attributeOldValue] = true
      end
    end

    if filter = hash[:filter]
      options[:attributeFilter] = filter
    end

    if cdata = hash[:cdata]
      options[:characterData] = true

      if cdata == :old
        options[:characterDataOldValue] = true
      end
    end

    options.to_n
  end
end

end; end
