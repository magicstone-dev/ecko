# frozen_string_literal: true

class StripeCallbacksController < Ecko::Plugins::Stripe::CallbacksController
  layout 'public'

  def success
    # Handle success Route here
  end

  def canceled
    # Handle Cancel Route here.
  end
end
