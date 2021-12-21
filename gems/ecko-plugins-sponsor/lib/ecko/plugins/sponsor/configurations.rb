# frozen_string_literal: true

module Ecko
  module Plugins
    module Sponsor
      # This error can be raised when no gateways are configured
      class NoGatewaysConfiguredError < StandardError; end

      class Configurations
        include Singleton
        attr_accessor :schema

        # Need to validate schema structure here
        def setup(schema)
          # Check any gateways where configured
          raise NoGatewaysConfiguredError if schema[:gateways].blank?

          # Validate configurations
          schema[:gateways].each do |gateway|
            Ecko::Plugins::Sponsor::SchemaValidator::GatewayValidator.validate(gateway)
            Ecko::Plugins::Sponsor.add_gateway(gateway)
          end

          @schema = schema
        end

        def gateways
          return { run: 'default', default: schema[:gateways].first } if schema[:gateways].length == 1

          { run: 'choice', choices: schema[:gateways] }
        end
      end
    end
  end
end
