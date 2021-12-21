# frozen_string_literal: true

module Ecko
  module Plugins
    module Sponsor
      class InvalidGatewayName < StandardError; end

      class InvalidGatewayCheckout < StandardError; end

      module SchemaValidator
        class Base
          attr_accessor :schema

          def initialize(schema)
            @schema = schema
          end

          class << self
            def validate(schema)
              new(schema).validate
            end
          end
        end

        class GatewayValidator < Base

          def validate
            # Validate name
            raise InvalidGatewayName if schema[:name].nil?

            # validate checkout
            raise InvalidGatewayCheckout if schema[:checkout].nil? || !schema[:checkout].is_a?(Class)
          end
        end
      end
    end
  end
end
