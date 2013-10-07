BROWSER_ENGINE = `/MSIE|WebKit|Presto|Gecko/.exec(navigator.userAgent)[0]`.downcase rescue :unknown

module Browser

module Compatibility
  def self.sizzle?
    defined?(`window.Sizzle`)
  end

  # FIXME: v
  # def self.respond_to?(parent = `window`, object, method)
  # ^
  def self.respond_to?(*args)
    if args.length == 2
      parent         = `window`
      object, method = args
    else
      parent, object, method = args
    end

    %x{
      if (!#{parent}) {
        return false;
      }

      var klass = #{parent}[#{object}];

      if (!klass) {
        return false;
      }

      return typeof(klass.prototype[#{method}]) === "function";
    }
  end

  # FIXME: v
  # def self.has?(parent = `window`, name)
  # ^
  def self.has?(*args)
    if args.length == 1
      parent = `window`
      name,  = args
    else
      parent, name = args
    end

    %x{
      if (!#{parent}) {
        return false;
      }

      return #{parent}[#{name}] != null;
    }
  end
end

C = Compatibility

end
