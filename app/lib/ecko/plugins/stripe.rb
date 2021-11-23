# frozen_string_literal: true

module Ecko::Plugins::Stripe
  class << self
    def register(schema)
      Ecko::Plugins.register(name: 'stripe', schema: schema, engine: Ecko::Plugins::Stripe::Engine)
    end
  end
end
