# Most specs can run on the client using opal-rspec.
# A few specs need the server-client communication to be tested
# so those run on the server using the hyper-spec rspec
# helpers.

# You can also run the opal-rspec specs in the browser which
# works fine, since you are in a full browser environment
# talking to a server.   However in this case we need to
# add the hyper-spec helpers in as pass throughs so the
# syntax works.

# See the Rakefile and config.ru for more details.

if RUBY_ENGINE != 'opal'
  # setup to run the server side specs
  require 'hyper-spec/rack'
  require 'opal-browser'

  ENV['RACK_ENV'] ||= 'test'

  require File.join(File.dirname(__FILE__), 'app.rb')

  Capybara.app = HyperSpecTestController.wrap(app: app, append_path: 'spec/app')

  # Setup Test Environment
  set :environment, :test
  set :run, false
  set :raise_errors, true
  set :logging, false

  module Helpers
    def html(html_string = '')
      before do
        # we can use the insert_html helper already built into
        # hyper-spec
        insert_html html_string
      end
    end

    # to make specs more readable rename :js flag to server_side_test
    # on the server, and on the client (see below) just skip the test
    def server_side_test
      :js # run in capybara js mode
    end
  end

  # allow use of server_side_test in outer scope as well

  def server_side_test
    :js # run in capybara js mode
  end

  RSpec.configure do |config|
    config.extend Helpers
  end

  HyperSpec.reset_between_examples = false

else
  require 'browser'
  require 'console'

  module Helpers
    # Add some html code to the body tag ready for testing. This will
    # be added before each test, then removed after each test. It is
    # convenient for adding html setup quickly. The code is wrapped
    # inside a div, which is directly inside the body element.
    #
    #     describe "DOM feature" do
    #       html <<-HTML
    #         <div id="foo"></div>
    #       HTML
    #
    #       it "foo should exist" do
    #         Document["#foo"]
    #       end
    #     end
    #
    # @param [String] html_string html content to add
    def html(html_string='')
      html = "<div id='opal-browser-spec'>#{html_string}</div>"
      before do
        @_spec_html = DOM(html)
        @_spec_html.append_to($document.body)
      end

      after { @_spec_html.remove }
    end

    # see comments above on the server side helpers
    def server_side_test
      :js # the js tag will be skipped on the client
    end
  end


  RSpec.configure do |config|
    config.extend Helpers
  end

  module RSpec
    module Expectations
      class ExpectationTarget
      end

      module HyperSpecInstanceMethods
        # stub the main helpers used by hyper-spec
        # not all of these are used currently, but we
        # add them all and alias them, so if specs change
        # in the future they are available,
        def to_on_client(matcher, message = nil, &block)
          evaluate_client('ruby').to(matcher, message, &block)
        end

        alias on_client_to to_on_client

        def to_on_client_not(matcher, message = nil, &block)
          evaluate_client('ruby').not_to(matcher, message, &block)
        end

        alias on_client_to_not to_on_client_not
        alias on_client_not_to to_on_client_not
        alias to_not_on_client to_on_client_not
        alias not_to_on_client to_on_client_not

        def to_then(matcher, message = nil, &block)
          evaluate_client('promise').to(matcher, message, &block)
        end

        alias then_to to_then

        def to_then_not(matcher, message = nil, &block)
          evaluate_client('promise').not_to(matcher, message, &block)
        end

        alias then_to_not to_then_not
        alias then_not_to to_then_not
        alias to_not_then to_then_not
        alias not_to_then to_then_not

        private

        def evaluate_client(*)
          # stubs the hyper-spec evaluate_client method (basically does nothing,
          # but execute the block)
          value = @target.call
          ExpectationTarget.for(value, nil)
        end
      end

      class BlockExpectationTarget < ExpectationTarget
        include HyperSpecInstanceMethods

        def with(*)
          self
        end
      end
    end
  end

end
