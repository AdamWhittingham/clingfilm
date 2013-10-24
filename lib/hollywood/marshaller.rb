require 'celluloid'
require 'celluloid/autostart'

require_relative 'messaging_wrapper'
require_relative 'pulse'

module Hollywood
  class Marshaller < Celluloid::SupervisionGroup
    alias_method :stop, :finalize
  end
end
