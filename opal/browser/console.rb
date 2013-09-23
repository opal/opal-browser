module Browser

# This class wraps a `window.console`.
class Console
  include Native::Base

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
    `#@native.log.apply(null, args)`

    self
  end

  # Log the passed objects based on an optional initial format as informational
  # log.
  def info(*args)
    `#@native.info.apply(null, args)`

    self
  end

  # Log the passed objects based on an optional initial format as warning.
  def warn(*args)
    `#@native.warn.apply(null, args)`

    self
  end

  # Log the passed objects based on an optional initial format as error.
  def error(*args)
    `#@native.error.apply(null, args)`

    self
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

    `#@native.group.apply(null, args)`

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

    `#@native.groupCollapsed.apply(null, args)`

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

end
