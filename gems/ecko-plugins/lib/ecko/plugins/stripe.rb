require 'ecko/plugins/stripe/engine'

module Ecko
  module Plugins
    module Stripe
      class << self
        def register(schema)
          Ecko::Plugins.register(name: 'stripe', schema: schema, engine: Ecko::Plugins::Stripe::Engine)
        end
      end
    end
  end
end
