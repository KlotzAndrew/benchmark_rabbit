require 'benchmark'
require 'bunny'

connection = Bunny.new(host: 'localhost')
connection.start

channel = connection.create_channel

def publish(channel, i)
  channel.default_exchange.publish(i.to_s, routing_key: 'benchmark')
end

counter = 10_000
no_confirms = Benchmark.measure do
  counter.times { |i| publish(channel, i) }
end

channel.confirm_select
channel.using_publisher_confirms?

confirms = Benchmark.measure do
  counter.times { |i| publish(channel, i + counter) }
  channel.wait_for_confirms
end

puts "non_confirms: #{no_confirms}"
puts "yes_confirms: #{confirms}"

channel.close
connection.close

exit
