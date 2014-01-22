#! /usr/bin/env ruby
require 'selenium/webdriver'
require 'net/https'
require 'json'

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

puts "\rRunning specs..."
puts

url = "http://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub.browserstack.com/wd/hub"
cap = Selenium::WebDriver::Remote::Capabilities.new

cap['platform']        = ENV['SELENIUM_PLATFORM'] || 'ANY'
cap['browser']         = ENV['SELENIUM_BROWSER'] || 'chrome'
cap['browser_version'] = ENV['SELENIUM_VERSION'] if ENV['SELENIUM_VERSION']

cap['browserstack.tunnel'] = 'true'
cap['browserstack.debug']  = 'false'

browser = Selenium::WebDriver.for(:remote, url: url, desired_capabilities: cap)
browser.navigate.to('http://localhost:9292')

at_exit {
  browser.quit
}

begin
  Selenium::WebDriver::Wait.new(timeout: 540, interval: 1) \
    .until { not browser.find_element(:css, 'p#totals').text.strip.empty? }

  totals   = browser.find_element(:css, 'p#totals').text
  duration = browser.find_element(:css, 'p#duration').find_element(:css, 'strong').text

  puts "#{totals} in #{duration}"
  puts

  if totals =~ /0 failures/
    exit 0
  end

  browser.find_elements(:css, '.example_group').slice_before {|x|
    begin
      x.find_element(:css, 'dd')

      false
    rescue Exception
      true
    end
  }.each {|header, *specs|
    next unless specs.any? { |x| x.find_element(:css, '.failed') rescue false }

    namespace = header.find_element(:css, 'dt').text

    specs.each {|group|
      next unless group.find_element(:css, '.failed') rescue false

      method = group.find_element(:css, 'dt').text

      group.find_elements(:css, 'dd.example.failed').each {|el|
        puts "#{namespace}#{method}"
        puts "  #{el.find_element(:css, '.failed_spec_name').text}"
        puts
        puts el.find_element(:css, '.failure').text
        puts
      }
    }
  }
rescue Selenium::WebDriver::Error::TimeOutError
  puts "The specs timed out, some asynchronous spec must have failed, good luck with that."
rescue Selenium::WebDriver::Error::NoSuchElementError
  puts 'ya blew it'
  puts browser.page_source
end

exit 1
