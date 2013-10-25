require 'celluloid'

module Hollywood
  class MessagingWrapper
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Logger

    attr_reader :exception, :channel

    def initialize content, input_channels, output_channel
      bounce_if_invalid content
      @content = content
      Array(input_channels).each{|channel| depends_on channel}
      updates output_channel
    end

    def wraps
      @content
    end

    def handle_message(channel, message)
      debug "<- #{channel}:#{message}"
      result = @content.update(message)
      announce_result(result) if result
    end

    def announce_result payload
      publish(@channel, payload)
      debug "-> #{@channel}:#{payload}"
    end

    def depends_on channel
      subscribe(channel, :handle_message)
    end

    def updates channel
      @channel = channel
    end

    def to_s
      "#{self.class}[#{@content.class}]"
    end

    private

    def bounce_if_invalid content
      raise "Cannot wrap an object which doesn't provide #update" unless content.respond_to? 'update'
    end
  end
end
