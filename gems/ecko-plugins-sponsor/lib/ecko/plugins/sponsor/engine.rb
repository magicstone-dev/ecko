# frozen_string_literal: true

require_relative 'configurations'
require_relative 'schema_validator'
require_relative 'process'

module Ecko
  module Plugins
    module Sponsor
      class Engine
        class << self
          def configure(schema)
            Ecko::Plugins::Sponsor::Configurations.instance.setup(schema)
          end

          def gateways
            Ecko::Plugins::Sponsor::Configurations.instance.gateways
          end

          def process(package_id, account)
            Ecko::Plugins::Sponsor::Process.run(package_id, account)
          end
        end
      end
    end
  end
end
