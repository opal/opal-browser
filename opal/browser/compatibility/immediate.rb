module Browser

module Compatibility
  def self.immediate?(prefix = nil)
    if prefix
      has?("#{prefix}SetImmediate")
    else
      has?(:setImmediate)
    end
  end

  def self.post_message?
    return false unless has?(:postMessage) && !has?(:importScripts)

    %x{
      var ok  = true,
          old = window.onmessage;

      window.onmessage = function() { ok = false; };
      window.postMessage("", "*")
      window.onmessage = old;

      return ok;
    }
  end

  def self.ready_state_change?
    `"onreadystatechange" in window.document.createElement("script")`
  end
end

class Immediate
  if C.immediate?
    def dispatch
      @id = `window.setImmediate(function() {
        #{@function.call(*@arguments, &@block)};
      })`
    end

    def prevent
      `window.clearImmediate(#@id)`
    end
  elsif C.immediate? :ms
    def dispatch
      @id = `window.msSetImmediate(function() {
        #{@function.call(@arguments, &@block)};
      })`
    end

    def prevent
      `window.msClearImmediate(#@id)`
    end
  elsif C.post_message?
    # @private
    @@tasks  = {}

    # @private
    @@prefix = "opal.browser.immediate.#{rand(1_000_000)}."

    $window.on :message do |e|
      if String === e.data && e.data.start_with?(@@prefix)
        if task = @@tasks.delete(e.data[@@prefix.length .. -1])
          task[0].call(*task[1], &task[2])
        end
      end
    end

    def dispatch
      @id          = rand(1_000_000).to_s
      @@tasks[@id] = [@function, @arguments, @block]

      $window.send! "#{@@prefix}#{@id}"
    end

    def prevent
      @@tasks.delete(@id)
    end
  elsif C.ready_state_change?
    def dispatch
      %x{
        var script = document.createElement("script");

        script.onreadystatechange = function() {
          if (!#{aborted?}) {
            #{@function.call(@arguments, &@block)};
          }

          script.onreadystatechange = null;
          script.parentNode.removeChild(script);
        };

        document.documentElement.appendChild(script);
      }
    end

    def prevent; end
  else
    def dispatch
      @id = `window.setTimeout(function() {
        #{@function.call(*@arguments, &@block)};
      }, 0)`
    end

    def prevent
      `window.clearTimeout(#@id)`
    end
  end
end

end
