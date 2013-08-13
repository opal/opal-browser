require 'bundler'
Bundler.require

apps = []
apps << Opal::Server.new { |s|
  s.main = 'opal/spec/sprockets_runner'
  s.append_path 'spec'
  s.debug = false
}

apps << Class.new(Sinatra::Base) {
  get '/http' do
    "lol"
  end

  post '/http' do
    if params['lol'] == 'wut'
      "ok"
    else
      "fail"
    end
  end

  put '/http' do
    if params['lol'] == 'wut'
      "ok"
    else
      "fail"
    end
  end

  delete '/http' do
    "lol"
  end

  get '/socket' do
    request.websocket do |ws|
      ws.onopen do
        ws.send 'lol'
      end

      ws.onmessage do |msg|
        ws.send msg
      end
    end
  end
}

run Rack::Cascade.new(apps)
