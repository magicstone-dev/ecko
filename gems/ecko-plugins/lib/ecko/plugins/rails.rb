# This will load the custom routes set by the app
require 'ecko/plugins/stripe/rails/routes'

module Ecko
  module Plugins
    class Engine < ::Rails::Engine
      config.ecko_plugins = Ecko::Plugins

      # Force routes to be loaded if we are doing any eager load.
      config.before_eager_load do |app|
        app.reload_routes!
      end
    end
  end
end
