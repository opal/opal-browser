require 'browser/dom/event'
require 'browser/dom/node_set'
require 'browser/dom/node'
require 'browser/dom/attribute'
require 'browser/dom/character_data'
require 'browser/dom/text'
require 'browser/dom/cdata'
require 'browser/dom/comment'
require 'browser/dom/element'
require 'browser/dom/document'
require 'browser/dom/document_fragment'

module Kernel
  def XML(what)
    %x{
      var doc;

      if (window.DOMParser) {
        doc = new DOMParser().parseFromString(what, 'text/xml');
      }
      else {
        doc       = new ActiveXObject('Microsoft.XMLDOM');
        doc.async = 'false';
        doc.loadXML(what);
      }
    }

    DOM(`doc`)
  end

  def DOM(what, document = $document)
    if String === what
      %x{
        var doc = #{Native.try_convert(document)}.createElement('div');
        doc.innerHTML = what;

        return #{DOM(`doc.childNodes.length == 1 ? doc.childNodes[0] : doc`)};
      }
    else
      Browser::DOM::Node.new(what)
    end
  end
end
