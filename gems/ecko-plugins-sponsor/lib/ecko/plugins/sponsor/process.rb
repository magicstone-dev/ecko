# frozen_string_literal: true

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
