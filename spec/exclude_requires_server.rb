RSpec.configure do |config|
  puts "************** required works!!!!!!! *****************"
  config.filter_run_excluding requires_server: true
  #config.formatter = :doc
end
