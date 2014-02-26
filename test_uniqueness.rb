require_relative 'bootstrap'

Sidekiq.redis do |conn|
  conn.set :counter, 0
end

(1..10).map do |i|
  Thread.new do
    10.times do
      Incrementer.perform_async
    end
  end
end.join

sleep 1

puts "Expecting the counter to = 1"
Sidekiq.redis do |conn|
  counter = conn.get :counter
  puts "counter = #{counter}"
end

