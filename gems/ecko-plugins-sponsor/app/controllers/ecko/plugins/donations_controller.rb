# frozen_string_literal: true

module Ecko
  module Plugins
    class DonationsController < 'ApplicationController'.constantize
      layout 'public'

      before_action :authenticate_user!
    end
  end
end
