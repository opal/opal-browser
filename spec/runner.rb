#! /usr/bin/env ruby
require 'selenium/webdriver'
require 'rest_client'
require 'json'

hub  = "http://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub.browserstack.com/wd/hub"
plan = "https://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@www.browserstack.com/automate/plan.json"
cap  = Selenium::WebDriver::Remote::Capabilities.new

cap['platform']        = ENV['SELENIUM_PLATFORM'] || 'ANY'
cap['browser']         = ENV['SELENIUM_BROWSER'] || 'chrome'
cap['browser_version'] = ENV['SELENIUM_VERSION'] if ENV['SELENIUM_VERSION']

cap['browserstack.tunnelIdentifier'] = ENV['TRAVIS_JOB_ID']
cap['browserstack.tunnel']           = 'true'
cap['browserstack.debug']            = 'false'

print 'Loading...'

begin
  loop do
    response = RestClient.get(plan)
    state    = JSON.parse(response.to_str)

    if state["parallel_sessions_running"] < state["parallel_sessions_max_allowed"]
      break
    end

    print '.'
    sleep 30
  end

  browser = Selenium::WebDriver.for(:remote, url: hub, desired_capabilities: cap)
  browser.navigate.to('http://localhost:9292')
rescue Exception
  retry
end

begin
  Selenium::WebDriver::Wait.new(timeout: 60, interval: 10).until {
    browser.find_element(:class, 'rspec-report')
  }
rescue Selenium::WebDriver::Error::TimeOutError
  puts "\rThe specs failed loading."
  browser.quit
  exit 1
rescue Exception
  browser.quit
  raise
end

print "\rRunning specs..."

begin
  Selenium::WebDriver::Wait.new(timeout: 1200, interval: 30).until {
    print '.'

    not browser.find_element(:id, 'totals').text.strip.empty?
  }

  totals   = browser.find_element(:id, 'totals').text
  duration = browser.find_element(:id, 'duration').find_element(:tag_name, 'strong').text

  print "\r#{totals} in #{duration}"

  if totals =~ / 0 failures/
    exit 0
  end
rescue Selenium::WebDriver::Error::TimeOutError
  print "\rTimeout, have fun."
ensure
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

  browser.quit
end

exit 1
