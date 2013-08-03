require 'bundler'
Bundler.require

apps = []
apps << Opal::Server.new { |s|
  s.main = 'opal/spec/sprockets_runner'
  s.append_path 'spec'
  s.debug = false
}

apps << Class.new(Sinatra::Base) {
  get '/test' do
    "lol"
  end

  post '/test' do
    puts params.inspect
    if params['lol'] == 'wut'
      "ok"
    else
      "fail"
    end
  end
}

run Rack::Cascade.new(apps)
