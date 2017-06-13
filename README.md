# Benchmarking RabbitMQ Producer confirms

### Running against localhost

Run a consumer to see messages (optional): `ruby consumer.rb`
Benchmark: `ruby benchmark.rb`

### Running against remote DO host

```shell
docker-machine create \
  --driver digitalocean \
  --digitalocean-access-token $DOTOKEN \
  rmq-host

docker run -d \
  --hostname my-rabbit \
  --name some-rabbit \
  -p 15672:15672 \
  -p 5672:5672 \
  rabbitmq:3-management
```

then:
`ruby consumer.rb $(docker-machine ip rmq-host)`

and:
`ruby benchmark.rb $(docker-machine ip rmq-host)`
