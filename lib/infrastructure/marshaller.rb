require 'celluloid'
require 'celluloid/autostart'
require 'logging'

require 'infrastructure/messaging_wrapper'
require 'infrastructure/pulse'

class Marshaller < Celluloid::SupervisionGroup
  alias_method :stop!, :finalize
  Celluloid.logger = Logging.logger['Backend']
end
