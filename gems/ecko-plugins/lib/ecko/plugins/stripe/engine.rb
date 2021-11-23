# frozen_string_literal: true
require 'ecko/plugins/stripe/configurations'

module Ecko
  module Plugins
    module Stripe
      class Engine
        class << self
          def configure(schema)
            Ecko::Plugins::Stripe::Configurations.instance.setup(schema)
          end
        end
      end
    end
  end
end
