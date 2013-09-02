require 'celluloid'
require 'logging'

class Pulse
  DEFAULT_INTERVAL = 600
  include Celluloid
  include Celluloid::Notifications

  attr_reader :channel

  def initialize(channel, options = {})
    @channel = channel
    @logger = Logging.logger.new(self)
    interval = options.fetch :interval, DEFAULT_INTERVAL
    unless ENV["DISABLE_HOLLYWOOD_POLLING"]
      every(interval) { pulse }
      pulse
    end
  end

  def pulse
    message = :update
    publish @channel, message
    @logger.info "sent #{@channel} -> #{message}"
  end
end
