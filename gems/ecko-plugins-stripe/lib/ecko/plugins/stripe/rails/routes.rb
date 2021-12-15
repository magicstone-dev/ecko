require "active_support/core_ext/object/try"
require "active_support/core_ext/hash/slice"

module ActionDispatch::Routing
  class Mapper

    # Sets all the stripe routes specification
    def stripe_callbacks(*resources)
      return if resources.first.nil?

      get :stripe_success, to: "#{resources.first}#success", as: :stripe_success_callback
      get :stripe_cancel, to: "#{resources.first}#cancel", as: :stripe_cancel_callback
    end
  end
end
