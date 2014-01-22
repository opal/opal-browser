module Browser; class Storage

unless C.local_storage?
  if C.global_storage?
    def init
      replace `#@window.globalStorage[#@window.location.hostname][#{encoded_name}] || '{}'`
    end

    def save
      `#@window.globalStorage[#@window.location.hostname][#{encoded_name}] = #{JSON.dump(self)}`
    end
  elsif C.add_behavior?
    def init
      %x{
        #@element = #@window.document.createElement('link');
        #@element.addBehavior('#default#userData');

        #@window.document.getElementsByTagName('head')[0].appendChild(#@element);

        #@element.load(#{encoded_name});
      }

      replace `#@element.getAttribute(#{encoded_name}) || '{}'`
    end

    def save
      %x{
        #@element.setAttribute(#{encoded_name}, #{JSON.dump(self)});
        #@element.save(#{encoded_name});
      }
    end
  else
    def init
      $document.cookies.options expires: 60 * 60 * 24 * 365

      replace $document.cookies[encoded_name]
    end

    def save
      $document.cookies[encoded_name] = self
    end
  end
end

end; end
