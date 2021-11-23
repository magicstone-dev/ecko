# frozen_string_literal: true

class Ecko::Plugins::Stripe::Engine
  class << self
    def configure(schema)
      Ecko::Plugins::Stripe::Configurations.instance.setup(schema)
    end
  end
end
