# drill

## 1.19.0

```sh
export ver="1.19.0"
```

### Download

```sh
wget https://dlcdn.apache.org/drill/drill-${ver}/apache-drill-${ver}.tar.gz --no-check-certificate
```

Install to `/opt`.

### Env

```sh
# don't use HADOOP_CLASSPATH for confliction.
unset HADOOP_CLASSPATH
```

### Config

```sh
sudo vi /opt/drill/conf/drill-override.conf
```

> ```text
> drill.exec: {
>    cluster-id: "las",
>    zk.connect: "las1:2181,las2:2181,las3:2181"
> }
> ```

```sh
for host in las2 las3; do
    for file in /opt/drill/conf/drill-override.conf; do
        scp "${file}" "${host}:${file}"
    done
done
```

### Run

#### Embedded

```sh
drill-embedded
```

#### Distributed

```sh
for host in las1 las2 las3; do
    ssh "${host}" "/opt/drill/bin/drillbit.sh start"
done
for host in las1 las2 las3; do
    ssh "${host}" "/opt/drill/bin/drillbit.sh stop"
done
```

### Usage

Command line

```sh
drill-localhost
```

Web UI

```sh
curl http://las1:8047/
```

In drill

```sql
!help
!tables -- show all tables.
!quit
```

```sql
use sys;
show tables; -- show tables in default schema.
select * from drillbits;
```
