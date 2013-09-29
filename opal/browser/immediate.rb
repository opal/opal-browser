require 'browser/compatibility/immediate'

module Browser

# FIXME: drop the immediate check when require order is fixed
class Immediate
  if C.immediate?
    def initialize(func, *args, &block)
      @aborted = false
      @id      = `window.setImmediate(function() {
        #{func.call(*args, &block)};
      })`
    end

    def abort
      return if aborted?

      @aborted = true
      `window.clearImmediate(#@id)`

      self
    end
  end

  def aborted?
    @aborted
  end
end

end

class Proc
  # Defer the function to be called as soon as possible.
  def defer(*args, &block)
    Browser::Immediate.new(self, *args, &block)
  end
end
