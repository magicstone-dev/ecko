# frozen_string_literal: true

require 'ecko/plugins/sponsor/parser/stripe'

module Ecko
  module Plugins
    module Sponsor
      class Process
        attr_accessor :package, :account

        def initialize(package_id, account)
          @package = ::DonationPackage.find(package_id)
          @account = account
        end

        def run
          send("run_#{gateways[:run]}")
        end

        # Add a formater here.
        def run_default
          value = Object.const_get("Ecko::Plugins::Sponsor::Parser::#{gateways[:default][:name]}").build(package, account)
          gateways[:default][:checkout].execute(value)
        end

        def gateways
          @gateways ||= Ecko::Plugins::Sponsor::Configurations.instance.gateways
        end

        class << self
          def run(package_id, account)
            new(package_id, account).run
          end
        end
      end
    end
  end
end
