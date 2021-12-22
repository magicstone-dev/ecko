# frozen_string_literal: true

module Ecko
  module Plugins
    module Sponsor
      module Parser
        class Stripe
          attr_reader :package, :account

          def initialize(package, account)
            @package = package
            @account = account
          end

          def build
            {
              submit_type: 'donate',
              success_message: 'Thanks for being part of our community, Your donation was well received', # Need to add translation options,
              callback: 'Ecko::Plugins::Sponsor::Donated',
              package_id: package.id,
              payable_type: account.class.name,
              payable_id: account.id,
              line_items: [
                {
                  quantity: 1,
                  amount: package.amount,
                  name: "#{package.title} Donation",
                  description: 'Donation for the instance',
                }
              ]
            }
          end

          class << self
            def build(package, account)
              new(package, account).build
            end
          end
        end
      end
    end
  end
end
