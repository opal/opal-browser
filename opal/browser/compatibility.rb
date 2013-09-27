begin
  BROWSER_ENGINE = `/MSIE|WebKit|Presto|Gecko/.exec(navigator.userAgent)[0]`.downcase
rescue
  BROWSER_ENGINE = :unknown
end

module Browser

module Compatibility
  def self.sizzle?
    defined?(`window.Sizzle`)
  end

  # FIXME: v
  # def self.has?(parent = `window`, object, method)
  # ^
  def self.has?(*args)
    if args.length == 2
      parent         = `window`
      object, method = args
    else
      parent, object, method = args
    end

    %x{
      var klass = #{parent}[#{object}];

      if (!klass) {
        return false;
      }

      return !!klass.prototype[#{method}];
    }
  end
end

end
