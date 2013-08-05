require 'bundler'
Bundler.require

map '/' do
  run Opal::Server.new { |s|
    s.main = 'opal/spec/sprockets_runner'
    s.append_path 'spec'
    s.debug = false
  }
end

map '/spec/http/' do
  run Class.new(Sinatra::Base) {
    get '/test' do
      "lol"
    end

    post '/test' do
      if params['lol'] == 'wut'
        "ok"
      else
        "fail"
      end
    end

    put '/test' do
      if params['lol'] == 'wut'
        "ok"
      else
        "fail"
      end
    end

    delete '/test' do
      "lol"
    end
  }.new
end

map '/spec/ws/' do
  run Class.new(Rack::WebSocket::Application) {

  }.new
end
