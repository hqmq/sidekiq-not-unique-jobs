require_relative 'bootstrap'

def many_workers
  (1..10).map do |i|
    Thread.new do
      10.times do
        Incrementer.perform_async
      end
    end
  end.join
end

def print_counter
  Sidekiq.redis do |conn|
    puts "counter = #{conn.get :counter}"
  end
end

# reset the db to get a clean run
Sidekiq.redis do |conn|
  conn.flushdb
  conn.set :counter, 0
end

many_workers
sleep 0.5 #let workers finish
puts "Expecting counter = 1"
print_counter

sleep 3 #less than 10 second timeout on class

many_workers
sleep 0.5 #let workers finish
puts "Expecting counter = 1"
print_counter

sleep 10 #let the uniqueness timeout occur

many_workers
sleep 0.5
puts "Expecting counter = 2"
print_counter
