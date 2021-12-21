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

          def checkout_reference
            Ecko::Plugins::Stripe::Checkout
          end

          def checkout(params)
            checkout_reference.execute(params)
          end
        end
      end
    end
  end
end
