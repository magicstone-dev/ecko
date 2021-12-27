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

    option :currency, type: :string, default: 'usd', aliases: [:c]
    option :visible, type: :boolean, default: true, aliases: [:v]
    option :reference, type: :string, default: 'silver_tier', aliases: [:r]
    desc 'donation packages', 'Create donation packages'
    long_desc <<-LONG_DESC
      Creates donation package which will be used to refer for donations
    LONG_DESC
    def create_package(title, amount, description)
      DonationPackage.create(
        amount: amount,
        currency: options[:currency],
        title: title,
        description: description,
        donation_reference: options[:reference],
        visible: options[:visible]
      )

      say("#{title} donation Package created", :green)
    end


    desc 'donation packages', 'Create donation packages'
    long_desc <<-LONG_DESC
      Removes donation package which already exists
    LONG_DESC
    def remove_package(title)
      package = DonationPackage.find_by(title: title)

      if package.nil?
        say("Donation Package with title #{title} doesnt exists", :red)
      else
        package.destroy!
        say("#{title} donation Package has been removed", :green)
      end
    end
  end
end
