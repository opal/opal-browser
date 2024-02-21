module Browser; module DOM; class Element < Node

class Media < Element
  alias_native :load
  alias_native :play
  alias_native :pause
  alias_native :time, :currentTime
  alias_native :time=, :currentTime=
end

class Video < Media
  def_selector "video"
end

class Audio < Media
  def_selector "audio"
end

end; end; end
