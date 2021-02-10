module Browser; module DOM; class Element < Node

class Data
  attr_reader :element

  def initialize(element)
    @element = element
    @native  = element.to_n

    unless defined?(`#@native.$data`)
      `#@native.$data = {}`
    end
  end

  include Enumerable

  def each(&block)
    return enum_for :each unless block

    %x{
      var data = #@native.$data;

      for (var key in data) {
        #{block.call `key`, `data[key]`};
      }
    }

    @element.attributes.each {|name, value|
      if name =~ /^data-(.*)$/
        block.call $1, value
      end
    }

    self
  end

  def assign(data)
    data.each {|name, value|
      self[name] = value
    }

    self
  end

  def [](name)
    if data = @element["data-#{name}"]
      return data
    end

    %x{
      var value = #@native.$data[name];

      if (value === undefined) {
        return nil;
      }
      else {
        return value;
      }
    }
  end

  def []=(name, value)
    `delete #@native.$data[name]`
    if [true, false, nil].include?(value)
      @element["data-#{name}"] = value
    elsif value.respond_to? :to_str
      @element["data-#{name}"] = value.to_str
    elsif value.respond_to? :to_int
      @element["data-#{name}"] = value.to_int.to_s
    else
      `#@native.$data[name] = value`
    end
  end

  def delete(name)
    data = self[name]
    self[name] = nil
    data
  end
end

end; end; end
