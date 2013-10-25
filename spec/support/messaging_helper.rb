require "celluloid"

class MessageHelper
  include Celluloid
  include Celluloid::Notifications
  attr_reader :has_updated, :messages

  def initialize channel='default'
    @messages = []
    subscribe(channel, :handle_message)
		@has_updated = false
  end

  def message_count
    @messages.size
  end

  def handle_message (channel, message)
    @messages << [channel, message]
    @has_updated = true
  end

	def updated?
		@has_updated
	end

  def reset
    @has_updated = false
  end
end
