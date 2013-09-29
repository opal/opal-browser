module Browser

module Compatibility
  def self.immediate?
    has? :setImmediate
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
  unless C.immediate?
    if C.post_message?
      @@tasks = {}
      @@prefix = "opal.browser.immediate.#{rand(1_000_000)}."

      $window.on :message do |e|
        if String === e.data && e.data.start_with?(@@prefix)
          if task = @@tasks.delete(e.data[@@prefix.length .. -1])
            task[0].call(*task[1], &task[2])
          end
        end
      end

      def initialize(func, *args, &block)
        @aborted     = false
        @id          = rand(1_000_000).to_s
        @@tasks[@id] = [func, args, block]

        $window.send! "#{@@prefix}#{@id}"
      end

      def abort
        return if aborted?

        @aborted = true
        @@tasks.delete(@id)

        self
      end
    elsif C.ready_state_change?
      def initialize(func, *args, &block)
        @aborted = false

        %x{
          var that   = #{self},
              script = document.createElement("script");

          script.onreadystatechange = function() {
            if (!#{`that`.aborted?}) {
              #{func.call(*args, &block)};
            }

            script.onreadystatechange = null;
            script.parentNode.removeChild(script);
          };

          document.documentElement.appendChild(script);
        }
      end

      def abort
        return if aborted?

        @aborted = true

        self
      end
    else
      def initialize(func, *args, &block)
        @aborted = false
        @id      = `window.setTimeout(function() {
          #{func.call(*args, &block)};
        }, 0)`
      end

      def abort
        return if aborted?

        @aborted = true
        `window.clearTimeout(#@id)`

        self
      end
    end
  end
end

end
