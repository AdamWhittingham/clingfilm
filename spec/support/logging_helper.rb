require 'logging'
require 'rspec/logging_helper'

RSpec.configure do |config|
  include RSpec::LoggingHelper
  config.capture_log_messages
end

def log_output
  fail "No log output found" unless @log_output
  @log_output.readlines.map{|s|s.strip.squeeze(" ")}.join "\n"
end
