# frozen_string_literal: true
require 'ecko/plugins/stripe/configurations'
require 'ecko/plugins/stripe/authenticator'
require 'ecko/plugins/stripe/checkout'

module Ecko
  module Plugins
    module Stripe
      class Engine
        class << self
          def configure(schema)
            Ecko::Plugins::Stripe::Configurations.instance.setup(schema)
          end

          def authenticate
            ::Stripe.api_key = Ecko::Plugins::Stripe::Configurations.instance.stripe_api_key
          end

          def checkout(params)
            Ecko::Plugins::Stripe::Checkout.execute(params)
          end
        end
      end
    end
  end
end
