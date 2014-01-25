#! /usr/bin/env ruby
require 'selenium/webdriver'
require 'net/https'
require 'json'

url = "http://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub.browserstack.com/wd/hub"
cap = Selenium::WebDriver::Remote::Capabilities.new

cap['platform']        = ENV['SELENIUM_PLATFORM'] || 'ANY'
cap['browser']         = ENV['SELENIUM_BROWSER'] || 'chrome'
cap['browser_version'] = ENV['SELENIUM_VERSION'] if ENV['SELENIUM_VERSION']

cap['browserstack.tunnel'] = 'true'
cap['browserstack.debug']  = 'false'

print 'Loading...'

begin
  loop do
    uri           = URI.parse("https://www.browserstack.com/automate/plan.json")
    agent         = Net::HTTP.new(uri.host, uri.port)
    agent.use_ssl = true
    request       = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(ENV['BS_USERNAME'], ENV['BS_AUTHKEY'])

    state = JSON.parse(agent.request(request).body)

    if state["parallel_sessions_running"] < state["parallel_sessions_max_allowed"]
      break
    end

    print '.'
    sleep 30
  end

  browser = Selenium::WebDriver.for(:remote, url: url, desired_capabilities: cap)
  browser.navigate.to('http://localhost:9292')
rescue Exception
  retry
end

def screenshot(browser)
  browser.capture_entire_page_screenshot('screenshot.png')
  request  = Net::HTTP.new('imgur.com')
  response = request.post('/api/upload.json', image: File.open('screenshot.png'))

  JSON.parse(response.body)['rsp']['image']['original_image']
end

print "\rRunning specs..."

begin
  Selenium::WebDriver::Wait.new(timeout: 1200, interval: 30).until {
    print '.'

    not browser.find_element(:css, 'p#totals').text.strip.empty?
  }

  totals   = browser.find_element(:css, 'p#totals').text
  duration = browser.find_element(:css, 'p#duration').find_element(:css, 'strong').text

  puts "\r#{totals} in #{duration}"
  puts

  if totals =~ / 0 failures/
    exit 0
  end

  puts screenshot(browser)
rescue Selenium::WebDriver::Error::NoSuchElementError
  puts browser.page_source
rescue Selenium::WebDriver::Error::TimeOutError
  puts "\rTimeout, have fun: #{screenshot(browser)}"

  exit 0
ensure
  browser.quit
end

exit 1
