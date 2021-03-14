require 'bundler'
Bundler.require

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

post '/http-file' do
  if params['lol'] == 'wut' &&
     params['file'][:filename] == 'yay.txt' &&
     params['file'][:tempfile].read == 'content'

    "ok"
  else
    "fail"
  end
end

get '/events' do
  headers 'Content-Type' => 'text/event-stream'

  stream do |out|
    sleep 0.2

    out << "data: lol\n" << "\n"
    out << "event: custom\n" << "data: omg\n" << "\n"
    out << "data: wut\n" << "\n"

    sleep 10
  end
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

module OpalSprocketsServer
  def self.opal
    @opal ||= Opal::Sprockets::Server.new do |s|
      s.append_path 'spec/app'
      s.main = 'application'
      s.debug = ENV['RACK_ENV'] != 'production'
    end
  end
end

def app
  Rack::Builder.app do
    map '/assets' do
      run OpalSprocketsServer.opal.sprockets
    end
    run Sinatra::Application
  end
end
