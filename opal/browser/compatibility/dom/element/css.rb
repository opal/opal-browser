module Browser; module DOM; class Element

if Browser.supports? :query, :css
  def css(path)
    %x{
      try {
        var result = #@native.querySelectorAll(path);

        return #{NodeSet.new(document,
          Native::Array.new(`result`))};
      }
      catch(e) {
        return #{NodeSet.new(document)};
      }
    }
  end
elsif Browser.loaded? :sizzle
  def css(path)
    NodeSet.new(document, `Sizzle(#{path}, #@native)`)
  end
end

end; end; end
