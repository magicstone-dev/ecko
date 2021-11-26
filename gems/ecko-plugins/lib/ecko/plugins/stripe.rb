require 'stripe'
require 'ecko/plugins/stripe/engine'
require 'ecko/plugins/stripe/rails/routes'

module Ecko
  module Plugins
    module Stripe

      class ExecutionError < StandardError; end

      class << self
        def register(schema)
          Ecko::Plugins.register(name: 'stripe', schema: schema, engine: Ecko::Plugins::Stripe::Engine)
        end
      end
    end
  end
end
