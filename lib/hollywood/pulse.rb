require 'celluloid'

module Hollywood
  class Pulse
    DEFAULT_INTERVAL = 600
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Logger

    attr_reader :channel

    def initialize(channel, options = {})
      @channel = channel
      interval = options.fetch :interval, DEFAULT_INTERVAL
      unless ENV["DISABLE_HOLLYWOOD_POLLING"]
        every(interval) { pulse }
        pulse
      end
    end

    def pulse
      publish @channel, :update
      debug "update -> #{@channel}"
    end
  end
end
