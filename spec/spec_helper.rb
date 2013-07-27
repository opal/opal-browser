require 'browser'

module OpalSpec
  class Example
    def self.html(string)
      html = "<div id='spec'>#{string}</div>"

      before {
        @html = DOM(html).append_to($document.body)
      }

      after {
        @html.remove
      }
    end
  end
end
