require "opal-browser"
require "opal-sprockets"

run Opal::Sprockets::Server.new { |s|
  s.main = 'application'
  s.append_path 'app'
  #s.index_path = 'index.html.erb'
  s.debug = true
}