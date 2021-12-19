# frozen_string_literal: true

class DonationsController < ApplicationController
  layout 'public'

  before_action :authenticate_user!

  def donate
    @packages = DonationPackage.visible
  end

  def payment_gateways
    processed = Ecko::Plugins.sponsor.process(params[:package], current_account)

    binding.pry
  end
end
