module Browser; module DOM

class ShadowRoot < DocumentFragment
  include DocumentOrShadowRoot

  # Use: Element#shadow
  def self.create
    raise ArgumentError
  end
end

end; end