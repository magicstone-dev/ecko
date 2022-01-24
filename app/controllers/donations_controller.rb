# frozen_string_literal: true

class DonationsController < ApplicationController
  layout 'public'

  before_action :authenticate_user!

  def donate
    @account = current_account
    @packages = DonationPackage.visible
  end

  def sponsors
    @donations = Donation.all
  end

  def payment_gateways
    processed = Ecko::Plugins.sponsor.process(params[:package], current_account)

    redirect_to(processed)
  end
end
