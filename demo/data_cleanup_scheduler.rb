# frozen_string_literal: true

class Scheduler::DataCleanupScheduler
  include Sidekiq::Worker

  sidekiq_options retry: 0, lock: :until_executed

  def perform
    Process.spawn('rails db:seed:replant --trace')
  end
end
