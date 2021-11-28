module Ecko
  module Plugins
    class StripeCallbacksController < 'ApplicationController'.constantize

      def success
        raise InvalidPaymentIntent if intent.nil?

        view_response
      end

      def intent
        @intent ||= StripePaymentIntent.find_by(code: params[:state])
      end

      def view_response; end
    end
  end
end
