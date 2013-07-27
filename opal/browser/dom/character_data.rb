module Browser; module DOM

class CharacterData < Node
  def data
    `#@native.data`
  end

  def append(string)
    `#@native.appendData(string)`

    self
  end

  def insert(string, offset = 0)
    `#@native.insertData(offset, string)`

    self
  end

  def delete(count, offset = 0)
    `#@native.deleteData(offset, count)`

    self
  end

  def replace(string, offset = 0, count = `#@native.length`)
    `#@native.replaceData(offset, count, string)`

    self
  end

  def substring(count, offset = 0)
    `#@native.substringData(offset, count)`
  end
end

end; end
