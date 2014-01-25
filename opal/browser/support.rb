BROWSER_ENGINE = `/MSIE|WebKit|Presto|Gecko/.exec(navigator.userAgent)[0]`.downcase rescue :unknown

module Browser
  # @private
  @support = `{}`

  def self.supports?(base, *extra)
    key = `base+extra`

    if defined?(`#@support[#{key}]`)
      return `#@support[#{key}]`
    end

    support = case base
      when :MutationObserver
        defined?(`window.MutationObserver`)

      when :WebSocket
        defined?(`window.WebSocket`)

      when :EventSource
        defined?(`window.EventSource`)

      when :XHR
        defined?(`window.XMLHttpRequest`)

      when :ActiveX
        defined?(`window.ActiveXObject`)

      when :query
        case extra.shift
        when :xpath
          defined?(`document.evaluate`)

        when :css
          defined?(`Element.prototype.querySelectorAll`)
        end

      when :localStorage
        defined?(`window.localStorage`)

      when :globalStorage
        defined?(`window.globalStorage`)

      when :sessionStorage
        defined?(`window.sessionStorage`)

      when :userData
        defined?(`document.body.addBehavior`)

      when :setImmediate
        case extra.shift
        when nil
          defined?(`window.setImmediate`)

        when :ie
          defined?(`window.msSetImmediate`)

        when :firefox, :mozilla, :gecko
          defined?(`window.mozSetImmediate`)

        when :opera
          defined?(`window.oSetImmediate`)

        when :chrome, :safari, :android, :webkit
          defined?(`window.webkitSetImmediate`)
        end

      when :getComputedStyle
        defined?(`window.getComputedStyle`)

      when :currentStyle
        defined?(`document.documentElement.currentStyle`)

      when :postMessage
        if defined?(`window.postMessage`) && !defined?(`window.importScripts`)
          %x{
            var ok  = true,
                old = window.onmessage;

            window.onmessage = function() { ok = false; };
            window.postMessage("", "*")
            window.onmessage = old;
          }

          `ok`
        end

      when :readystatechange
        `"onreadystatechange" in window.document.createElement("script")`

      when :window
        case extra.shift
        when :innerHeight
          defined?(`window.innerHeight`)

        when :innerWidth
          defined?(`window.innerWidth`)

        when :scrollLeft
          defined?(`document.documentElement.scrollLeft`)

        when :scrollTop
          defined?(`document.documentElement.scrollTop`)

        when :pageXOffset
          defined?(`window.pageXOffset`)

        when :pageYOffset
          defined?(`window.pageYOffset`)
        end

      when :event
        case extra.shift
        when :constructor
          begin
            `new MouseEvent("click")`

            true
          rescue
            false
          end

        when :create
          defined?(`document.createEvent`)

        when :createObject
          defined?(`document.createEventObject`)

        when :addListener
          defined?(`document.addEventListener`)

        when :attach
          defined?(`document.attachEvent`)

        when :removeListener
          defined?(`document.removeEventListener`)

        when :detach
          defined?(`document.detachEvent`)

        when :dispatch
          defined?(`document.dispatchEvent`)

        when :fire
          defined?(`document.fireEvent`)
        end

      when :document
        case extra.shift
        when :defaultView
          defined?(`document.defaultView`)

        when :parentWindow
          defined?(`document.parentWindow`)
        end

      when :element
        case extra.shift
        when :clientHeight
          defined?(`document.documentElement.clientHeight`)

        when :clientWidth
          defined?(`document.documentElement.clientWidth`)

        when :scrollLeft
          defined?(`document.documentElement.scrollLeft`)

        when :scrollTop
          defined?(`document.documentElement.scrollTop`)

        when :textContent
          defined?(`document.documentElement.textContent`)

        when :innerText
          defined?(`document.documentElement.innerText`)

        when :matches
          case extra.shift
          when nil
            defined?(`Element.prototype.matches`)

          when :ie
            defined?(`Element.prototype.msMatchesSelector`)

          when :firefox, :mozilla, :gecko
            defined?(`Element.prototype.mozMatchesSelector`)

          when :opera
            defined?(`Element.prototype.oMatchesSelector`)

          when :chrome, :safari, :android, :webkit
            defined?(`Element.prototype.webkitMatchesSelector`)
          end
        end

      when :history
        case extra.shift
        when nil
          defined?(`window.history.pushState`)

        when :state
          defined?(`window.history.state`)
        end

      when :animation
        case extra.shift
        when :request
          case extra.shift
          when nil
            defined?(`window.requestAnimationFrame`)

          when :ie
            defined?(`window.msRequestAnimationFrame`)

          when :firefox, :mozilla, :gecko
            defined?(`window.mozRequestAnimationFrame`)

          when :opera
            defined?(`window.oRequestAnimationFrame`)

          when :chrome, :safari, :android, :webkit
            defined?(`window.webkitRequestAnimationFrame`)
          end

        when :cancel
          case extra.shift
          when nil
            defined?(`window.cancelAnimationFrame`)

          when :ie
            defined?(`window.msCancelAnimationFrame`)

          when :firefox, :mozilla, :gecko
            defined?(`window.mozCancelAnimationFrame`)

          when :opera
            defined?(`window.oCancelAnimationFrame`)

          when :chrome, :safari, :android, :webkit
            defined?(`window.webkitCancelAnimationFrame`)
          end

        when :cancelRequest
          case extra.shift
          when nil
            defined?(`window.cancelRequestAnimationFrame`)

          when :ie
            defined?(`window.msCancelRequestAnimationFrame`)

          when :firefox, :mozilla, :gecko
            defined?(`window.mozCancelRequestAnimationFrame`)

          when :opera
            defined?(`window.oCancelRequestAnimationFrame`)

          when :chrome, :safari, :android, :webkit
            defined?(`window.webkitCancelRequestAnimationFrame`)
          end
        end
    end

    `#@support[#{key}] = #{support}`
  end

  def self.loaded?(name)
    case name
    when :sizzle
      defined?(`window.Sizzle`)

    when :wgxpath
      defined?(`window.wgxpath`)
    end
  end
end
