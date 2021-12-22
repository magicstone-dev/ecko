# frozen_string_literal: true

require 'concurrent'
require_relative '../../config/boot'
require_relative '../../config/environment'
require_relative 'cli_helper'

module Mastodon
  class DonationsCLI < Thor
    include CLIHelper

    def self.exit_on_failure?
      true
    end

    desc 'donation packages', 'Create donation packages'
    long_desc <<-LONG_DESC
      Creates donation packages which will be used to refer for donations
    LONG_DESC
    def create_packages
      DonationPackage.destroy_all
      packages = [
        {
          id: 1,
          amount: 10,
          currency: 0,
          title: 'Silver',
          description: 'Silver Packages',
          donation_reference: 'silver_tier',
          visible: true,
        },
        {
          id: 2,
          amount: 100,
          currency: 0,
          title: 'Gold',
          description: 'Gold Packages',
          donation_reference: 'gold_tier',
          visible: true,
        },
        {
          id: 3,
          amount: 200,
          currency: 0,
          title: 'Platinum',
          description: 'Platinum Packages',
          donation_reference: 'platinum_tier',
          visible: true,
        },
      ]
      packages.each do |package|
        DonationPackage.create(package)
      end

      say("#{packages.length} Donation Packages created", :green)
    end
  end
end
