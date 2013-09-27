module Browser; module DOM; class Element

unless Compatibility.has?(:Element, :querySelectorAll)
  if Compatibility.sizzle?
    def css(path)
      NodeSet.new(document, `Sizzle(#{path}, #@native`)
    end
  else
    def css(*)
      raise NotImplementedError, 'fetching by selector unsupported'
    end
  end
end

end; end; end
