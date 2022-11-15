require 'bundler'
Bundler.require

apps = []

require 'opal/rspec'

Opal::Config.arity_check_enabled = true
Opal::Config.enable_source_location = true if Opal::Config.respond_to? :enable_file_source_location=
Opal::Config.enable_file_source_embed = true if Opal::Config.respond_to? :enable_file_source_embed=

Opal.append_path "#{__dir__}/spec"

apps << Opal::SimpleServer.new do |s|
  require_relative './spec/browser_runner_compat'

  $locator = Opal::RSpec::Locator.new(
    pattern:      'spec/**/*_spec.{rb,opal}',
    default_path: 'spec'
  )

  s.index_path = 'spec/browser_runner_index.html.erb'
end

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

run Rack::Cascade.new(apps.reverse)
