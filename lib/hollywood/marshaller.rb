require 'celluloid'
require 'celluloid/autostart'
require 'logging'

require_relative 'messaging_wrapper'
require_relative 'pulse'

class Marshaller < Celluloid::SupervisionGroup
  alias_method :stop!, :finalize
  Celluloid.logger = Logging.logger['Backend']
end
