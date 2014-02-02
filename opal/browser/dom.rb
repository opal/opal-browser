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
require 'browser/dom/builder'
require 'browser/dom/mutation_observer'

module Kernel
  # Parse an XML string into a DOM usable {Browser::DOM::Document}
  #
  # @param what [String] the string to parse
  # @return [Browser::DOM::Document] the document
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

  # Wrap a native element or create a DOM tree using the {Paggio::HTML} DSL.
  #
  # @return [Browser::DOM::Node]
  def DOM(*args, &block)
    if block
      document = args.shift || $document
      roots    = Browser::DOM::Builder.new(document, &block).to_a

      if roots.length == 1
        roots.first
      else
        Browser::DOM::NodeSet.new(roots)
      end
    else
      what     = args.shift
      document = args.shift || $document

      if native?(what)
        Browser::DOM::Node.new(what)
      elsif Browser::DOM::Node === what
        what
      elsif String === what
        %x{
          var doc = #{Native.try_convert(document)}.createElement('div');
          doc.innerHTML = what;

          return #{DOM(`doc.childNodes.length == 1 ? doc.childNodes[0] : doc`)};
        }
      else
        raise ArgumentError, "argument not DOM convertible"
      end
    end
  end
end

module Browser

class Window
  # Get the {DOM::Document} for this window.
  #
  # @return [DOM::Document]
  def document
    DOM(`#@native.document`)
  end
end

end

$document = $window.document
