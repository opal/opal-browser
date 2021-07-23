require 'roda'
require 'tilt/sass'
require 'tilt/opal'
require 'opal/builder_processors'
require 'opal-browser'

class OpalBuilder < Opal::Builder
  attr_accessor :build_source_map

  def to_s
    if @build_source_map
      super + "\n" + source_map.to_data_uri_comment
    else
      super
    end
  end
end

class App < Roda
  js_builder = OpalBuilder.new(stubs: []) #'opal'
  js_builder.build_source_map = ENV['RACK_ENV'] == 'development'
  js_builder.append_paths('app')

  plugin :assets, js: ['application.rb'],
                  js_opts: { builder: js_builder },
                  path: '.',
                  js_dir: 'app',
                  timestamp_paths: true,
                  precompiled: ENV['RACK_ENV'] != 'development' ? 'public/assets/assets-precompiled.json' : nil
  plugin :public

  route do |r|
    r.public
    r.assets

    r.root do
      <<~END
	      <!doctype html>
        <html>
          <head>
            <title>My application</title>
          </head>
          <body>
            #{ assets :js }
          </body>
        </html>
      END
    end
  end
end
