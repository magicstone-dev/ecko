# frozen_string_literal: true

module Ecko
  module Plugins
    module Sponsor
      class Donated
        attr_accessor :intent, :account, :package

        def initialize(intent)
          @intent = intent
          @account = ::Account.find(intent.payable_id)
          @package = ::DonationPackage.find(intent.metadata['package_id'])
        end

        def process
          create_donation && update_account_sponsorship && close_intent
        end

        private

        def update_account_sponsorship
          account.refresh_sponsorship
        end

        def close_intent
          intent.update(status: 'closed')
        end

        def create_donation
          ::Donation.create(account: account, amount: package.amount)
        end

        class << self
          def process(intent)
            new(intent).process
          end
        end
      end
    end
  end
end
