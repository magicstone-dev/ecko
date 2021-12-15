# frozen_string_literal: true

require_relative "stripe/version"
require 'stripe'
require 'ecko/plugins/stripe/engine'
require 'ecko/plugins/stripe/generators/payment_intent_generator'
require 'ecko/plugins/stripe/rails'

module Ecko
  module Plugins
    module Stripe

      class ExecutionError < StandardError; end

      # This error will be thrown when line items are not provided
      class InvalidLineItemError < StandardError; end

      # This error will be thrown if amount is not provided or it is 0
      # or string is provided
      class InvalidAmountError < StandardError; end

      # This error will be thrown if quantity is set to zero
      class InvalidQuantityError < StandardError; end

      # This error will be thrown if name of a line item is not provided
      class InvalidNameError < StandardError; end

      # When payment Intent is not found this error is thrown
      class InvalidPaymentIntent < StandardError; end

      class << self
        def register(schema)
          Ecko::Plugins.register(name: 'stripe', schema: schema, engine: Ecko::Plugins::Stripe::Engine)
        end
      end
    end
  end
end
