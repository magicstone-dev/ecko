# frozen_string_literal: true

module Ecko
  module Plugins
    module Stripe
      class Configurations
        include Singleton
        attr_accessor :schema

        def setup(schema)
          @schema = schema
        end

        def stripe_api_key
          schema[:stripe_api_key]
        end
      end
    end
  end
end
