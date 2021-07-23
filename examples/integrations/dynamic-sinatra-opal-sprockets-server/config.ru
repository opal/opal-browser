require 'opal-sprockets'
require 'opal-browser'
require 'sinatra'

opal = Opal::Sprockets::Server.new {|s|
  s.append_path 'app'
  s.main = 'application'
  s.debug = ENV['RACK_ENV'] != 'production'
}

map '/assets' do
  run opal.sprockets
end

get '/' do
  <<-HTML
    <!doctype html>
    <html>
      <head>
        <title>My Application</title>
      </head>
      <body>
        #{ Opal::Sprockets.javascript_include_tag('application', debug: opal.debug, sprockets: opal.sprockets, prefix: 'assets/' ) }
      </body>
    </html>
  HTML
end

run Sinatra::Application