module Browser; module HTTP

class Parameters < Hash
  def to_str
    to_a.map { |a| a.map(&:encode_uri_component).join('=') }.join('&')
  end
end

end; end
