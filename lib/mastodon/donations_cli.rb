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

    desc 'create_packages', 'Create donation packages'
    long_desc <<-LONG_DESC
      Creates default donation packages of $2, $10, and $50
    LONG_DESC
    def create_packages
      DonationPackage.destroy_all
      packages = [
        {
          id: 1,
          amount: 2,
          currency: 0,
          title: 'Silver',
          description: 'Silver Level',
          donation_reference: 'silver_tier',
          visible: true,
        },
        {
          id: 2,
          amount: 10,
          currency: 0,
          title: 'Gold',
          description: 'Gold Level',
          donation_reference: 'gold_tier',
          visible: true,
        },
        {
          id: 3,
          amount: 50,
          currency: 0,
          title: 'Platinum',
          description: 'Platinum Level',
          donation_reference: 'platinum_tier',
          visible: true,
        },
      ]
      packages.each do |package|
        DonationPackage.create(package)
      end

      say("#{packages.length} donation packages created", :green)
    end

    option :currency, type: :string, default: 'usd', aliases: [:c]
    option :visible, type: :boolean, default: true, aliases: [:v]
    option :reference, type: :string, default: 'silver_tier', aliases: [:r]
    desc 'create_package <title> <amount> <description> [OPTIONS]', 'Create donation package'
    long_desc <<-LONG_DESC
      Creates donation package based on supplied arguments.
        <title>             name shown on donate page
        <amount>            in whole dollars or euros
        <description>       descriptive text shown on donate page
        -c, --currency      usd or eur (default: usd)
        -v, --visible       visible on donate page (default: true)
        -r, --reference     silver_tier, gold_tier or platinum_tier for badge color
    LONG_DESC
    def create_package(title, amount, description)
      ActiveRecord::Base.connection.reset_pk_sequence!('donation_packages')
      DonationPackage.create(
        amount: amount,
        currency: options[:currency],
        title: title,
        description: description,
        donation_reference: options[:reference],
        visible: options[:visible]
      )

      say("#{title} donation package created", :green)
    end


    desc 'remove_package <title>', 'Remove donation package by title'
    long_desc <<-LONG_DESC
      Removes donation package from the database.
        <title>             name of package on donate page
    LONG_DESC
    def remove_package(title)
      package = DonationPackage.find_by(title: title)

      if package.nil?
        say("Donation package with title #{title} doesn't exist", :red)
      else
        package.destroy!
        say("#{title} donation package has been removed", :green)
      end
    end
  end
end
