require 'celluloid'
require 'logging'

Celluloid.logger = Logging.logger.new(Celluloid.to_s)
Celluloid.shutdown_timeout = 1

# Reboot celluloid; ESSENTIAL in avoiding state overflowing between tests
RSpec.configure do |config|
	config.before(:each, celluloid: true) do
		Celluloid.shutdown
		Celluloid.boot
	end
end
