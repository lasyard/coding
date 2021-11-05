# hbase

## 2.4.8

```sh
export ver="2.4.8"
```

### Download

```sh
wget https://dlcdn.apache.org/hbase/${ver}/hbase-${ver}-bin.tar.gz --no-check-certificate
```

Install to `/opt`.

```sh
# for ${hbase.tmp.dir}
sudo mkdir -p /opt/tmp/hbase
```

### Config

```sh
sudo vi /opt/hbase/conf/hbase-env.sh
```

> ```sh
> export JAVA_HOME=/usr
> export HBASE_MANAGES_ZK=false
> ```

```sh
sudo vi /opt/hbase/conf/hbase-site.xml
```

> ```xml
> <configuration>
>     <property>
>         <name>hbase.cluster.distributed</name>
>         <value>true</value>
>     </property>
>     <property>
>         <name>hbase.tmp.dir</name>
>         <value>/opt/tmp/hbase</value>
>     </property>
>     <property>
>         <name>hbase.rootdir</name>
>         <value>hdfs://las1:9000/hbase</value>
>     </property>
>     <property>
>         <name>hbase.zookeeper.quorum</name>
>         <value>las1,las2,las3</value>
>     </property>
> </configuration>
> ```

```sh
sudo vi /opt/hbase/conf/regionservers
```

> ```text
> las1
> las2
> las3
> ```

```sh
for host in las2 las3; do
    for file in /opt/hbase/conf/{hbase-env.sh,hbase-site.xml,regionservers}; do
        scp "${file}" "${host}:${file}"
    done
done
```

### Run

Start hdfs & zookeeper first.

```sh
start-hbase.sh
stop-hbase.sh
```

### Usage

```sh
hbase shell
```

In hbase shell

```sql
help
quit
```

```sh
curl http://las1:16010/
```
