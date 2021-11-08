# kafka

## 3.0.0

```sh
export ver="3.0.0"
```

### Download

```sh
wget https://dlcdn.apache.org/kafka/${ver}/kafka_2.13-${ver}.tgz --no-check-certificate
```

Install to `/opt`.

```sh
# for ${log.dirs}
sudo mkdir -p /opt/tmp/kafka
```

### Config

```sh
sudo vi /opt/kafka/config/server.properties
```

> ```properties
> broker.id=0
> log.dirs=/opt/tmp/kafka
> num.partitions=1
> log.retention.hours=24
> zookeeper.connect=las1:2181,las2:2181,las3:2181
> ```

```sh
for host in las2 las3; do
    for file in /opt/kafka/config/server.properties; do
        scp "${file}" "${host}:${file}"
    done
done
```

```sh
for i in {1..3}; do
    ssh "las${i}" "sed -i -e \"/broker.id=/c\\\\broker.id=${i}\" /opt/kafka/config/server.properties"
done
```

### Run

```sh
for host in las1 las2 las3; do
    ssh "$host" "/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties"
done
for host in las1 las2 las3; do
    ssh "$host" "/opt/kafka/bin/kafka-server-stop.sh"
done
```

### Usage

```sh
kafka-topics.sh --bootstrap-server localhost:9092 --list
kafka-topics.sh --bootstrap-server localhost:9092 --create --topic test --partitions 3 --replication-factor 1
kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic test
kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic test
```

```sh
kafka-console-producer.sh --bootstrap-server localhost:9092 --topic test
kafka-console-consumer.sh --bootstrap-server localhost:9092 --from-beginning --topic test
```

```sh
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --list
```
