# spark

## 3.2.0

```sh
export ver="3.2.0"
```

### Download

```sh
wget https://dlcdn.apache.org/spark/spark-${ver}/spark-${ver}-bin-hadoop3.2.tgz --no-check-certificate
```

Install to `/opt`.

### Config

```sh
sudo vi /opt/spark/conf/workers
```

> ```text
> las1
> las2
> las3
> ```

```sh
for host in las2 las3; do
    for file in /opt/spark/conf/workers; do
        scp "${file}" "${host}:${file}"
    done
done
```

### Run

```sh
# Conflict with hadoop's `start-all.sh` and `stop-all.sh`
/opt/spark/sbin/start-all.sh
/opt/spark/sbin/stop-all.sh
```

### Usage

```sh
curl http://las1:8080/
```

**NOTE**: Spark workers is binding to 8081, which conflict with Flink.

```sh
spark-submit --master spark://las1:7077 /opt/spark/examples/src/main/python/pi.py 10
```
