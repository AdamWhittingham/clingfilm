require "celluloid"

class MessageHelper
  include Celluloid
  include Celluloid::Notifications
  attr_reader :has_updated, :messages

  def initialize channel='default'
    @messages = []
    subscribe(channel, :handle_message)
  end

  def message_count
    @messages.size
  end

  def handle_message (channel, message)
    @messages << [channel, message]
    if message == :updated
      @has_updated = true
    end
  end

  def reset
    @has_updated = false
  end
end
