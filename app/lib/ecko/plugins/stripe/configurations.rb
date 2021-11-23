# frozen_string_literal: true

class Ecko::Plugins::Stripe::Configurations
  include Singleton
  attr_accessor :schema

  def setup(schema)
    @schema = schema
  end

  def stripe_api_key
    schema[:stripe_api_key]
  end
end
