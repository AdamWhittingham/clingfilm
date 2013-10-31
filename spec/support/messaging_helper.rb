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
  end

	def updated?
		message_count > 0
	end

  def reset
    @has_updated = false
  end
end
