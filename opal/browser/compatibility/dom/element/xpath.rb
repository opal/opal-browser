module Browser; module DOM; class Element

if Browser.supports?(:query, :xpath) || Browser.loaded?(:wgxpath)
  if Browser.loaded?(:wgxpath)
    `wgxpath.install()`
  end

  def xpath(path)
    %x{
      try {
        var result = (#@native.ownerDocument || #@native).evaluate(path,
          #@native, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);

        return #{NodeSet.new(document,
          Native::Array.new(`result`, get: :snapshotItem, length: :snapshotLength))};
      }
      catch (e) {
        return #{NodeSet.new(document)};
      }
    }
  end
end

end; end; end
