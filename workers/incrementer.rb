class Incrementer
  include Sidekiq::Worker
  sidekiq_options :unique => true

  def perform
    Sidekiq.redis do |conn|
      conn.incr :counter
    end
  end
end
