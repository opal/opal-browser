# backtick_javascript: true
warn "`console' has been moved to Opal's stdlib, please `require 'console'` instead." if RUBY_ENGINE_VERSION.to_f >= 0.9

module Browser

# Manipulate the browser console.
#
# @see https://developer.mozilla.org/en-US/docs/Web/API/console
class Console
  include Browser::NativeCachedWrapper

  # Clear the console.
  def clear
    `#@native.clear()`
  end

  # Print a stacktrace from the call site.
  def trace
    `#@native.trace()`
  end

  # Log the passed objects based on an optional initial format.
  def log(*args)
    `#@native.log.apply(#@native, args)`
  end

  # Log the passed objects based on an optional initial format as informational
  # log.
  def info(*args)
    `#@native.info.apply(#@native, args)`
  end

  # Log the passed objects based on an optional initial format as warning.
  def warn(*args)
    `#@native.warn.apply(#@native, args)`
  end

  # Log the passed objects based on an optional initial format as error.
  def error(*args)
    `#@native.error.apply(#@native, args)`
  end

  # Time the given block with the given label.
  def time(label, &block)
    raise ArgumentError, "no block given" unless block

    `#@native.time(label)`

    begin
      if block.arity == 0
        instance_exec(&block)
      else
        block.call(self)
      end
    ensure
      `#@native.timeEnd()`
    end
  end

  # Group the given block.
  def group(*args, &block)
    raise ArgumentError, "no block given" unless block

    `#@native.group.apply(#@native, args)`

    begin
      if block.arity == 0
        instance_exec(&block)
      else
        block.call(self)
      end
    ensure
      `#@native.groupEnd()`
    end
  end

  # Group the given block but collapse it.
  def group!(*args, &block)
    return unless block_given?

    `#@native.groupCollapsed.apply(#@native, args)`

    begin
      if block.arity == 0
        instance_exec(&block)
      else
        block.call(self)
      end
    ensure
      `#@native.groupEnd()`
    end
  end
end

class Window
  # Get the {Console} for this window.
  #
  # @return [Console]
  def console
    Console.new(`#@native.console`)
  end
end

$console = $window.console

end
