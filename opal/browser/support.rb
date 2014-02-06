# The engine the browser is running on.
#
# Keep in mind it uses the user agent to know, so it's not reliable in case of
# spoofing.
BROWSER_ENGINE = `/MSIE|WebKit|Presto|Gecko/.exec(navigator.userAgent)[0]`.downcase rescue :unknown

module Browser
  # @private
  @support = `{}`

  # Check if the browser supports the given feature.
  def self.supports?(feature)
    if defined?(`#@support[#{feature}]`)
      return `#@support[#{feature}]`
    end

    support = case feature
      when 'MutationObserver'
        defined?(`window.MutationObserver`)

      when 'WebSocket'
        defined?(`window.WebSocket`)

      when 'EventSource'
        defined?(`window.EventSource`)

      when 'XHR'
        defined?(`window.XMLHttpRequest`)

      when 'ActiveX'
        defined?(`window.ActiveXObject`)

      when 'WebSQL'
        defined?(`window.openDatabase`)

      when 'Query.css'
        defined?(`document.querySelectorAll`)

      when 'Query.xpath'
        defined?(`document.evaluate`)

      when 'Storage.local'
        defined?(`window.localStorage`)

      when 'Storage.global'
        defined?(`window.globalStorage`)

      when 'Storage.session'
        defined?(`window.sessionStorage`)

      when 'Immediate'
        defined?(`window.setImmediate`)

      when 'Immediate (Internet Explorer)'
        defined?(`window.msSetImmediate`)

      when 'Immediate (Firefox)'
        defined?(`window.mozSetImmediate`)

      when 'Immediate (Opera)'
        defined?(`window.oSetImmediate`)

      when 'Immediate (Chrome)', 'setImmediate (Safari)'
        defined?(`window.webkitSetImmediate`)

      when 'CSS.computed'
        defined?(`window.getComputedStyle`)

      when 'CSS.current'
        defined?(`document.documentElement.currentStyle`)

      when 'Window.send'
        defined?(`window.postMessage`)

      when 'Window.send (Asynchronous)'
        if defined?(`window.postMessage`) && !defined?(`window.importScripts`)
          %x{
            var ok  = true,
                old = window.onmessage;

            window.onmessage = function() { ok = false; };
            window.postMessage("", "*")
            window.onmessage = old;

            return ok;
          }
        end

      when 'Window.send (Synchronous)'
        !supports?('Window.send (Asynchronous)')

      when 'Window.innerSize'
        defined?(`window.innerHeight`)

      when 'Window.outerSize'
        defined?(`window.outerHeight`)

      when 'Window.scroll'
        defined?(`document.documentElement.scrollLeft`)

      when 'Window.pageOffset'
        defined?(`window.pageXOffset`)

      when 'Attr.isId'
        %x{
          var div = document.createElement('div');
              div.setAttribute('id', 'xxxxxxxxxxxxx');

          return typeof(div.attributes['id'].isId) !== "undefined";
        }

      when 'Element.addBehavior'
        defined?(`document.documentElement.addBehavior`)

      when 'Element.className'
        %x{
          var div = document.createElement("div");
              div.setAttribute('className', 'x');

          return div.className === 'x';
        }

      when 'Element.class'
        %x{
          var div = document.createElement("div");
              div.setAttribute('class', 'x');

          return div.className === 'x';
        }

      when 'Element.for'
        %x{
          var label = document.createElement("label");
              label.setAttribute('for', 'x');

          return label.htmlFor === 'x';
        }

      when 'Element.htmlFor'
        %x{
          var label = document.createElement("label");
              label.setAttribute('htmlFor', 'x');

          return label.htmlFor === 'x';
        }

      when 'Element.clientSize'
        defined?(`document.documentElement.clientHeight`)

      when 'Element.scroll'
        defined?(`document.documentElement.scrollLeft`)

      when 'Element.textContent'
        defined?(`document.documentElement.textContent`)

      when 'Element.innerText'
        defined?(`document.documentElement.innerText`)

      when 'Element.matches'
        defined?(`document.documentElement.matches`)

      when 'Element.matches (Internet Explorer)'
        defined?(`document.documentElement.msMatchesSelector`)

      when 'Element.matches (Firefox)'
        defined?(`document.documentElement.mozMatchesSelector`)

      when 'Element.matches (Opera)'
        defined?(`document.documentElement.oMatchesSelector`)

      when 'Element.matches (Chrome)', 'Element.matches (Safari)'
        defined?(`document.documentElement.webkitMatchesSelector`)

      when 'Element.getBoundingClientRect'
        defined?(`document.documentElement.getBoundingClientRect`)

      when 'Event.readystatechange'
        `"onreadystatechange" in window.document.createElement("script")`

      when 'Event.constructor'
        begin
          `new MouseEvent("click")`

          true
        rescue
          false
        end

      when 'Event.create'
        defined?(`document.createEvent`)

      when 'Event.createObject'
        defined?(`document.createEventObject`)

      when 'Event.addListener'
        defined?(`document.addEventListener`)

      when 'Event.attach'
        defined?(`document.attachEvent`)

      when 'Event.removeListener'
        defined?(`document.removeEventListener`)

      when 'Event.detach'
        defined?(`document.detachEvent`)

      when 'Event.dispatch'
        defined?(`document.dispatchEvent`)

      when 'Event.fire'
        defined?(`document.fireEvent`)

      when /^Event\.([A-Z].*?)$/
        `(#{$1} + "Event") in window`

      when 'Document.view'
        defined?(`document.defaultView`)

      when 'Document.window'
        defined?(`document.parentWindow`)

      when 'History'
        defined?(`window.history.pushState`)

      when 'History.state'
        defined?(`window.history.state`)

      when 'Animation.request'
        defined?(`window.requestAnimationFrame`)

      when 'Animation.request (Internet Explorer)'
        defined?(`window.msRequestAnimationFrame`)

      when 'Animation.request (Firefox)'
        defined?(`window.mozRequestAnimationFrame`)

      when 'Animation.request (Opera)'
        defined?(`window.oRequestAnimationFrame`)

      when 'Animation.request (Chrome)', 'Animation.request (Safari)'
        defined?(`window.webkitRequestAnimationFrame`)

      when 'Animation.cancel'
        defined?(`window.cancelAnimationFrame`)

      when 'Animation.cancel (Internet Explorer)'
        defined?(`window.msCancelAnimationFrame`)

      when 'Animation.cancel (Firefox)'
        defined?(`window.mozCancelAnimationFrame`)

      when 'Animation.cancel (Opera)'
        defined?(`window.oCancelAnimationFrame`)

      when 'Animation.cancel (Chrome)', 'Animation.cancel (Safari)'
        defined?(`window.webkitCancelAnimationFrame`)

      when 'Animation.cancelRequest'
        defined?(`window.cancelRequestAnimationFrame`)

      when 'Animation.cancelRequest (Internet Explorer)'
        defined?(`window.msCancelRequestAnimationFrame`)

      when 'Animation.cancelRequest (Firefox)'
        defined?(`window.mozCancelRequestAnimationFrame`)

      when 'Animation.cancelRequest (Opera)'
        defined?(`window.oCancelRequestAnimationFrame`)

      when 'Animation.cancelRequest (Chrome)', 'Animation.cancelRequest (Safari)'
        defined?(`window.webkitCancelRequestAnimationFrame`)
    end

    `#@support[#{feature}] = #{support}`
  end

  # Check if the given polyfill is loaded.
  def self.loaded?(name)
    case name
    when 'Sizzle'
      defined?(`window.Sizzle`)

    when 'wicked-good-xpath'
      defined?(`window.wgxpath`)
    end
  end
end
