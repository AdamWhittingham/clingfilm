require "celluloid"

class ActorHelper
  include Celluloid

  def [](name)
    Celluloid::Actor[name]
  end
end

module Clingfilm
  class MessagingWrapper
    def crash_me message= 'Crashed by tests!'
      raise message
    end
  end
end
