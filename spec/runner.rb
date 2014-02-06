#! /usr/bin/env ruby
require 'selenium/webdriver'
require 'rest_client'
require 'json'

# setup tunnel
begin
  File.open('BrowserStackTunnel.jar', 'w') {|f|
    f.write RestClient.get('http://www.browserstack.com/BrowserStackTunnel.jar').to_str
  }

  tunnel = IO.popen 'java -jar BrowserStackTunnel.jar $BS_AUTHKEY localhost,9292,0 -tunnelIdentifier $TRAVIS_JOB_ID'

  loop do
    break if tunnel.gets.start_with? 'You can now access'
  end
rescue
  retry
end

# configure based on environment variables
hub  = "http://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub.browserstack.com/wd/hub"
plan = "https://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@www.browserstack.com/automate/plan.json"
cap  = Selenium::WebDriver::Remote::Capabilities.new

cap['platform']        = ENV['SELENIUM_PLATFORM'] || 'ANY'
cap['browser']         = ENV['SELENIUM_BROWSER'] || 'chrome'
cap['browser_version'] = ENV['SELENIUM_VERSION'] if ENV['SELENIUM_VERSION']
cap['device']          = ENV['SELENIUM_DEVICE'] if ENV['SELENIUM_DEVICE']

cap['browserstack.tunnelIdentifier'] = ENV['TRAVIS_JOB_ID']
cap['browserstack.tunnel']           = true
cap['browserstack.debug']            = true

cap['databaseEnabled']          = true
cap['browserConnectionEnabled'] = true
cap['locationContextEnabled']   = true
cap['webStorageEnabled']        = true

print 'Loading...'

# wait until there's a spot in the parallel jobs
begin
  loop do
    state = JSON.parse(RestClient.get(plan).to_str)

    if state["parallel_sessions_running"] < state["parallel_sessions_max_allowed"]
      break
    end

    print '.'
    sleep 30
  end

  browser = Selenium::WebDriver.for(:remote, url: hub, desired_capabilities: cap)
  browser.navigate.to('http://localhost:9292')
rescue Selenium::WebDriver::Error::UnknownError
  retry
end

# if we don't quit the browser it will stall
at_exit {
  browser.quit
}

# the title is a good way to know if anything went wrong while fetching the
# page
Selenium::WebDriver::Wait.new(timeout: 30, interval: 5).until {
  not browser.title.strip.empty?
}

unless browser.title =~ /Opal Browser/
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
  Selenium::WebDriver::Wait.new(timeout: 1200, interval: 30).until {
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
rescue Selenium::WebDriver::Error::TimeOutError
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
