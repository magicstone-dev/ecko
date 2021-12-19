# frozen_string_literal: true

require_relative 'sponsor/version'
require_relative 'sponsor/engine'

module Ecko
  module Plugins
    module Sponsor
      class Error < StandardError; end
      @@gateways = []

      class << self
        # It will add all the gateways here to be able to redirect when someone tries to donate
        # If none of the gateways are configured there are no ways to donate
        # Therefore an error will be thrown
        def add_gateway(checkout)
          @@gateways << checkout
        end

        def available_gateways
          return { run: 'default', default: @@gateways.first } if @@gateways.length == 1

          { run: 'choice', choices: @@gateways }
        end

        # THis will register the sponsor engine to the ecko plugin registry
        def register(schema)
          Ecko::Plugins.register(name: 'sponsor', schema: schema, engine: Ecko::Plugins::Sponsor::Engine)
        end
      end
    end
  end
end
