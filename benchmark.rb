require 'benchmark'
require 'benchmark/ips'

require 'bunny'

host = ARGV[0] || 'localhost'
puts "host: #{host}"

connection = Bunny.new(host: host)
connection.start

channel = connection.create_channel

confirm_channel = connection.create_channel
confirm_channel.confirm_select
confirm_channel.using_publisher_confirms?

def publish(channel, i)
  channel.default_exchange.publish(i.to_s, routing_key: 'benchmark')
end

puts "Benchmark ips"
Benchmark.ips do |x|
  x.report('yes-confirm:') do |_times|
    publish(confirm_channel, 2)
    confirm_channel.wait_for_confirms
  end
  x.report('non-confirm:') do |_times|
    publish(channel, 1)
  end
  x.compare!
end

puts "Benchmark"
n = 1000
Benchmark.bm do |x|
  x.report('yes-confirm:') do
    n.times do |i|
      publish(confirm_channel, i + n)
      confirm_channel.wait_for_confirms
    end
  end
  x.report('non-confirm:') do
    n.times do |i|
      publish(channel, i)
    end
  end
end

channel.close
connection.close
