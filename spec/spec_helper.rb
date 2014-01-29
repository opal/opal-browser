require 'browser'
require 'browser/console'

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
