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
          params[:quantity] || ['card']
        end

        def line_items
          params[:line_items]
        end

        def success_url
          "http://localhost:3000/stripe/callbacks/success?state=#{state}&session_id={CHECKOUT_SESSION_ID}"
        end

        def cancel_url
          "http://localhost:3000/stripe/callbacks/cancel?state=#{state}"
        end

        def state
          { intent: 'intent_id' }
        end
      end
    end
  end
end
