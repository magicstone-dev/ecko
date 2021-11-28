# frozen_string_literal: true

class StripeCallbacksController < Ecko::Plugins::StripeCallbacksController
  layout 'public'

  def canceled
    # Handle Cancel Route here.
  end
end
