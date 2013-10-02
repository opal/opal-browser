require 'json2'
require 'sizzle'

require 'browser'

module OpalSpec
  class Example
    def self.html(string)
      before {
        @html = DOM("<div id='opal-browser-spec'>#{string}</div>").append_to($document.body)
      }

      after {
        @html.remove
      }
    end
  end
end
