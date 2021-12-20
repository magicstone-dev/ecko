module Ecko
  module Plugins
    class StripeCallbacksController < 'ApplicationController'.constantize

      def success
        raise Ecko::Plugins::Stripe::InvalidPaymentIntent if intent.nil?

        @message = intent.metadata['success_message']
        Object.const_get(intent.metadata['callback']).process(intent)

        view_response
      end

      def intent
        @intent ||= StripePaymentIntent.find_by(code: params[:state])
      end

      def view_response; end
    end
  end
end
