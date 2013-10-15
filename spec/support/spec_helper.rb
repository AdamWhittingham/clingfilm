$:.unshift 'lib'

require 'bundler/setup'
require "simplecov" # Needs to be done first
require 'logging'
require 'rspec/logging_helper'

require_relative 'actor_helper'
require_relative 'logging_helper'
require_relative 'coverage_helper'
require_relative 'celluloid_hooks'

RSpec.configure do |config|
  config.color_enabled = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

def production_code
  spec = caller[0][/spec.+\.rb/]
  './' + spec.gsub('_spec','').gsub(/spec\//, 'lib/')
end
