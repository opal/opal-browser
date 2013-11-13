module Browser

# This class wraps a `window.console`.
class Console
  include Native

  # Clear the console.
  #
  # @return [self]
  def clear
    `#@native.clear()`

    self
  end

  # Print a stacktrace from the call site.
  #
  # @return [self]
  def trace
    `#@native.trace()`

    self
  end

  # Log the passed objects based on an optional initial format.
  #
  # @return [self]
  def log(*args)
    `#@native.log.apply(#@native, args)`

    self
  end

  # Log the passed objects based on an optional initial format as informational
  # log.
  #
  # @return [self]
  def info(*args)
    `#@native.info.apply(#@native, args)`

    self
  end

  # Log the passed objects based on an optional initial format as warning.
  #
  # @return [self]
  def warn(*args)
    `#@native.warn.apply(#@native, args)`

    self
  end

  # Log the passed objects based on an optional initial format as error.
  #
  # @return [self]
  def error(*args)
    `#@native.error.apply(#@native, args)`

    self
  end

  # Time the given block with the given label.
  #
  # @return [self]
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

    self
  end

  # Group the given block.
  #
  # @return [self]
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

    self
  end

  # Group the given block but collapse it.
  #
  # @return [self]
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

    self
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
