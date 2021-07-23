require 'roda'
require 'opal-browser'

# See: https://github.com/hmdne/roda-sprockets/issues/1
require_relative './bugfix'

class App < Roda
  plugin :sprockets, precompile: %w(application.js),
                     prefix: %w(app/),
                     root: __dir__,
                     public_path: 'public/assets/',
                     opal: true,
                     debug: ENV['RACK_ENV'] != 'production'
  plugin :public

  route do |r|
    r.public
    r.sprockets

    r.root do
      <<~END
	      <!doctype html>
        <html>
          <head>
            <title>My application</title>
          </head>
          <body>
            #{ javascript_tag 'application' }
            #{ opal_require 'application' }
          </body>
        </html>
      END
    end
  end
end
