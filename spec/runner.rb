#! /usr/bin/env ruby
require 'webdrivers'
require 'selenium/webdriver'
require 'rest_client'
require 'json'

print 'Loading...'

browser, options = case ENV['BROWSER']
when "chrome"
  opts = Selenium::WebDriver::Chrome::Options.new(args: ['--no-sandbox', '--headless'])
  [:chrome, options: opts]
when "gecko"
  opts = Selenium::WebDriver::Firefox::Options.new(args: ['--headless'])
  [:firefox, options: opts]
when "safari"
  opts = Selenium::WebDriver::Safari::Options.new(args: ['--headless'])
  [:safari, {}]
when "edge"
  opts = Selenium::WebDriver::Edge::Options.new(args: ['--headless'])
  [:edge, {}]
else
  raise "Wrong web browser provided in BROWSER. Acceptable values: chrome, gecko, safari, edge"
end

browser = Selenium::WebDriver.for(browser, options, **{})
browser.navigate.to('http://localhost:9292')

# if we don't quit the browser it will stall
at_exit {
  browser.quit
}

# the title is a good way to know if anything went wrong while fetching the
# page
Selenium::WebDriver::Wait.new(timeout: 30, interval: 5).until {
  not browser.title.strip.empty?
}

unless browser.title =~ /Opal Browser|RSpec results/
  puts "\rThe page failed loading."
  exit 1
end

# wait until the specs are running or there has been an error in the loading of
# the specs
begin
  Selenium::WebDriver::Wait.new(timeout: 30, interval: 5).until {
    (browser['rspec-error'] rescue false) ||
    (browser[class: 'rspec-report'] rescue false)
  }

  if element = browser['rspec-error'] rescue nil
    puts "\r#{element.text}"
    exit 1
  end
rescue Selenium::WebDriver::Error::TimeOutError; end

print "\rRunning specs..."

begin
  # wait until the specs have finished, thus changing the content of #totals
  Selenium::WebDriver::Wait.new(timeout: 3000, interval: 30).until {
    print '.'

    not browser['totals'].text.strip.empty?
  }

  totals   = browser['totals'].text
  duration = browser[css: '#duration strong'].text

  print "\r#{totals} in #{duration}"

  # no failures, happy times
  if totals =~ / 0 failures/
    exit 0
  end
rescue Selenium::WebDriver::Error::TimeoutError
  if element = browser['rspec-error'] rescue nil
    print "\r#{element.text}"
  else
    print "\rThe specs have timed out."
  end
ensure
  # take a screenshot and upload it to imgur
  begin
    browser.save_screenshot('screenshot.png')
    response = RestClient.post('https://api.imgur.com/3/upload',
      { image: File.open('screenshot.png') },
      { 'Authorization' => 'Client-ID 1979876fe2a097e' })

    print " ("
    print JSON.parse(response.to_str)['data']['link']
    puts  ")"
  rescue Exception
    puts
  end
end

exit 1
