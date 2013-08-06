module Browser; module HTTP

class Binary
  include Native::Base

  def initialize(*)
    super

    if String === @native
      @type = :string
      @data = @native
    else
      @type = :buffer
      @data = @native.to_a
    end
  end

  def [](index)
    @type == :string ? `#@data.charCodeAt(index) & 0xff` : @data[index]
  end
end

end; end
