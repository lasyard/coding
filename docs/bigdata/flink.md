# flink

## 1.14.0

```sh
export ver="1.14.0"
```

### Install

```sh
wget https://dlcdn.apache.org/flink/flink-${ver}/flink-${ver}-bin-scala_2.12.tgz --no-check-certificate
```

Install to `/opt`.

```sh
# for ${io.tmp.dirs}
sudo mkdir -p /opt/tmp/flink
```

### Config

```sh
sudo vi /opt/flink/conf/flink-conf.yaml
```

> ```yaml
> jobmanager.rpc.address: las1
> taskmanager.numberOfTaskSlots: 8
> io.tmp.dirs: /opt/tmp/flink
> jobmanager.memory.process.size: 2048m
> taskmanager.memory.process.size: 2048m
> ```

```sh
sudo vi /opt/flink/conf/masters
```

> ```text
> las1:8081
> ```

```sh
sudo vi /opt/flink/conf/workers
```

> ```text
> las1
> las2
> las3
> ```

```sh
for host in las2 las3; do
    for file in /opt/flink/conf/{flink-conf.yaml,masters,workers}; do
        scp "${file}" "${host}:${file}"
    done
done
```

### Run

```sh
start-cluster.sh
stop-cluster.sh
```

### Usage

#### standalone

```sh
curl http://las1:8081/
```

```sh
flink run flink-dataset-1.0.0-SNAPSHOT.jar
flink run flink-streaming-1.0.0-SNAPSHOT.jar
```

#### on yarn

```sh
export HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
export HADOOP_CLASSPATH="`hadoop classpath`"
flink run -t yarn-per-job flink-dataset-1.0.0-SNAPSHOT.jar
```

**NOTE**:

```sh
${taskmanager.numberOfTaskSlots} <= ${yarn.scheduler.maximum-allocation-vcores}
${taskmanager.memory.process.size} <= ${yarn.scheduler.maximum-allocation-mb}
```

### SQL client

Install SQL kafka connector

```sh
wget https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka_2.11/${ver}/flink-sql-connector-kafka_2.11-${ver}.jar
```

```sh
for host in las1 las2 las3; do
    scp "flink-sql-connector-kafka_2.11-${ver}.jar" "${host}:/opt/flink/lib"
done
```

```sh
sql-client.sh
```

In SQL client

```sql
help;
quit;
```

#### Test

```sh
cat << EOF | kafka-console-producer.sh --bootstrap-server localhost:9092 --topic people
1,Alice
2,Betty
3,Cindy
EOF

cat << EOF | kafka-console-producer.sh --bootstrap-server localhost:9092 --topic words
1,1,"I am Alice."
2,1,"Nice to meet you."
3,2,"I am Betty."
EOF

sql-client.sh
```

```sql
-- kafka connector does not support primary key.
create table people (
    id int,
    name varchar(64)
) with (
    'connector' = 'kafka',
    'topic' = 'people',
    'properties.bootstrap.servers' = 'localhost:9092',
    'properties.group.id' = 'test',
    'scan.startup.mode' = 'earliest-offset',
    'format' = 'csv'
);

create table words (
    id int,
    person int,
    word varchar(128)
) with (
    'connector' = 'kafka',
    'topic' = 'words',
    'properties.bootstrap.servers' = 'localhost:9092',
    'properties.group.id' = 'test',
    'scan.startup.mode' = 'earliest-offset',
    'format' = 'csv'
);

select * from people;

select * from words;

select name, word from words join people on words.person = people.id;

drop table people;
drop table words;
```
