# zookeeper

## 3.7.0

```sh
export ver="3.7.0"
```

### Install

```sh
wget https://dlcdn.apache.org/zookeeper/zookeeper-${ver}/apache-zookeeper-${ver}-bin.tar.gz --no-check-certificate
```

Install to `/opt`.

```sh
# for ${dataDir}
sudo mkdir -p /opt/tmp/zookeeper
```

### Config

```sh
sudo vi /opt/zookeeper/conf/zoo.cfg
```

> ```prop
> tickTime=2000
> dataDir=/opt/tmp/zookeeper
> clientPort=2181
> initLimit=5
> syncLimit=2
> server.1=las1:2888:3888
> server.2=las2:2888:3888
> server.3=las3:2888:3888
> # Default AdminServer port is 8080, so we don't need it
> admin.enableServer=false
> ```

```sh
for i in {1..3}; do
    ssh "las${i}" "echo \"${i}\" | sudo tee /opt/tmp/zookeeper/myid"
done
```

```sh
for host in las2 las3; do
    for file in /opt/zookeeper/conf/zoo.cfg; do
        scp "${file}" "${host}:${file}"
    done
done
```

### Run

```sh
for host in las1 las2 las3; do
    ssh "${host}" "/opt/zookeeper/bin/zkServer.sh start"
done
for host in las1 las2 las3; do
    ssh "${host}" "/opt/zookeeper/bin/zkServer.sh stop"
done
```

### Usage

```bash
zkCli.sh -server las1
```
