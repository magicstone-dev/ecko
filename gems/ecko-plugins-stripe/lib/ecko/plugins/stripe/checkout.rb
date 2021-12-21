# frozen_string_literal: true

module Ecko
  module Plugins
    module Stripe
      class Checkout < Authenticator
        def run
          session.url
        end

        # Creates a session based on the parameters send
        def session
          @session ||= ::Stripe::Checkout::Session.create(
            payment_method_types: payment_method_types,
            mode: 'payment',
            submit_type: 'book',
            client_reference_id: SecureRandom.uuid,
            success_url: success_url,
            cancel_url: cancel_url,
            line_items: line_items
          )
        end

        private

        def payment_method_types
          params[:types] || ['card']
        end

        def line_items
          raise Ecko::Plugins::Stripe::InvalidLineItemError unless valid_line_items?

          params[:line_items].map do |line_item|
            amount = line_item[:amount].to_i

            raise Ecko::Plugins::Stripe::InvalidAmountError if amount.zero?

            quantity = line_item[:quantity].to_i

            raise Ecko::Plugins::Stripe::InvalidQuantityError if quantity.zero?

            raise Ecko::Plugins::Stripe::InvalidNameError if line_item[:name].nil?

            {
              name: line_item[:name],
              description: line_item[:description],
              images: line_item[:images],
              amount: amount * 100, # Stripe takes values for cents
              currency: line_item[:currency] || default_currency,
              quantity: quantity,
            }
          end
        end

        def success_url
          "#{callback}/stripe_success?state=#{state}&session_id={CHECKOUT_SESSION_ID}"
        end

        def cancel_url
          "#{callback}/stripe/callbacks/cancel?state=#{state}"
        end

        def state
          payment_intent.code
        end

        def default_currency
          Ecko::Plugins::Stripe::Configurations.instance.currency
        end

        def callback
          @callback ||= Ecko::Plugins::Stripe::Configurations.instance.callback
        end

        def valid_line_items?
          params[:line_items].present? && params[:line_items].is_a?(Array)
        end

        def intent
          params[:intent]
        end

        def payment_intent
          @payment_intent ||= intent || ::StripePaymentIntent.create(
            reference: 'payment_only',
            metadata: params.as_json,
            payable_type: params[:payable_type],
            payable_id: params[:payable_id]
          )
        end
      end
    end
  end
end
