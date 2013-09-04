require "celluloid"

class ActorHelper
  include Celluloid

  def [](name)
    Celluloid::Actor[name]
  end
end

module Hollywood
  class MessagingWrapper
    def crash_me
      raise 'Crashed by tests!'
    end
  end
end
