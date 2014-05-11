class Incrementer
  include Sidekiq::Worker
  sidekiq_options(:unique => true,
                  :unique_job_expiration => 10,
                  :unique_unlock_order => :never)

  def perform
    Sidekiq.redis do |conn|
      conn.incr :counter
    end
  end
end
