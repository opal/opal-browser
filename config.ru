require 'bundler'
Bundler.require

apps = []

sprockets_env = Opal::RSpec::SprocketsEnvironment.new(spec_pattern         = 'spec/**/*_spec.{rb,opal}',
                                                      spec_exclude_pattern = nil,
                                                      spec_files           = nil,
                                                      default_path         = 'spec')

apps << Opal::Sprockets::Server.new(sprockets: sprockets_env) { |s|
  s.main = 'opal/rspec/sprockets_runner'
  s.append_path 'spec'
  s.index_path = 'index.html.erb'
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
}

run Rack::Cascade.new(apps)
