require 'bunny'

host = ARGV[0] || 'localhost'
puts "host: #{host}"

conn = Bunny.new(host: host)
conn.start

ch = conn.create_channel
q = ch.queue('benchmark', exclusive: true)

begin
  puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"
  q.subscribe(block: true) do |_delivery_info, _properties, body|
    puts " [x] Received #{body}"
  end
rescue Interrupt => _
  ch.close
  conn.close
end
