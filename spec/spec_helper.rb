if RUBY_ENGINE != 'opal'
  require 'hyper-spec'
  require 'opal-browser'

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path('../test_app/config/environment', __FILE__)

  require 'rspec/rails'

  module HtmlHelper
    def html(html_string='')
      before do
        insert_html html_string
      end
    end
  end

  RSpec.configure do |config|
    config.extend HtmlHelper
  end
else
  require 'browser'
  require 'console'

  module HtmlHelper
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
  end


  RSpec.configure do |config|
    config.extend HtmlHelper
  end

  module RSpec
    module Expectations
      class ExpectationTarget
      end

      module HyperSpecInstanceMethods
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

        def evaluate_client(method)
          # stubs the hyper-spec evaluate_client method (basically does nothing, but execute the block)
          value = @target.call
          ExpectationTarget.for(value, nil)
        end
      end

      class BlockExpectationTarget < ExpectationTarget
        include HyperSpecInstanceMethods

        def with(args)
          self
        end
      end
    end
  end

end
