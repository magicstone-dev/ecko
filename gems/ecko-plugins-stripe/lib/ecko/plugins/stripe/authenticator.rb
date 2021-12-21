# frozen_string_literal: true
require 'ecko/plugins/stripe/configurations'

module Ecko
  module Plugins
    module Stripe
      class Authenticator
        attr_reader :params

        def initialize(params)
          @params = params
          ::Ecko::Plugins.stripe.authenticate
        end

        def run
          raise Ecko::Plugins::ExecutionError
        end

        def state_secret
          Ecko::Plugins::Stripe::Configurations.instance.state_secret
        end

        class << self
          def execute(params)
            new(params).run
          end
        end
      end
    end
  end
end
