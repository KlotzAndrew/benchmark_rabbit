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


### Output

```
host: localhost

Benchmark ips
Warming up --------------------------------------
        yes-confirm:   194.000  i/100ms
        non-confirm:   613.000  i/100ms
Calculating -------------------------------------
        yes-confirm:    400.876k (±21.9%) i/s -      1.844M in   4.984916s
        non-confirm:      5.123M (±38.4%) i/s -     19.278M in   4.952445s

Comparison:
        non-confirm::  5122705.5 i/s
        yes-confirm::   400876.1 i/s - 12.78x  slower

Benchmark
       user     system      total        real
yes-confirm:  0.270000   0.060000   0.330000 (  0.566223)
non-confirm:  0.100000   0.020000   0.120000 (  0.174308)
```
```
host: 104.236.40.70

Benchmark ips
Warming up --------------------------------------
yes-confirm:     5.000  i/100ms
non-confirm:   765.000  i/100ms
Calculating -------------------------------------
yes-confirm:    302.081  (± 3.6%) i/s -      1.510k in   5.005607s
non-confirm:      6.888M (±43.3%) i/s -     24.637M in   4.942423s

Comparison:
non-confirm::  6888447.2 i/s
yes-confirm::      302.1 i/s - 22803.30x  slower

Benchmark
user     system      total        real
yes-confirm:  0.440000   0.120000   0.560000 ( 16.611437)
non-confirm:  0.080000   0.020000   0.100000 (  0.105749)
```
