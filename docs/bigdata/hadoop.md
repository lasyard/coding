# hadoop

## 3.3.1

```sh
export ver="3.3.1"
```

### Download

```sh
wget https://dlcdn.apache.org/hadoop/common/hadoop-${ver}/hadoop-${ver}.tar.gz --no-check-certificate
```

Install to `/opt`.

```sh
# for ${hadoop.tmp.dir}
sudo mkdir -p /opt/tmp/hadoop
```

### Env

```sh
echo "export HADOOP_HOME=\"/opt/hadoop\"" | sudo tee -a /etc/profile.d/hadoop.sh
# flink will use this.
echo "export HADOOP_CLASSPATH=\"\$(\${HADOOP_HOME}/bin/hadoop classpath)\"" | sudo tee -a /etc/profile.d/hadoop.sh
```

### Config

#### hdfs

```sh
sudo vi /opt/hadoop/etc/hadoop/hadoop-env.sh
```

> ```sh
> export JAVA_HOME=/usr
> # User privilege
> export HDFS_NAMENODE_USER=root
> export HDFS_DATANODE_USER=root
> export HDFS_SECONDARYNAMENODE_USER=root
> export YARN_RESOURCEMANAGER_USER=root
> export YARN_NODEMANAGER_USER=root
> ```

```sh
sudo vi /opt/hadoop/etc/hadoop/core-site.xml
```

> ```xml
> <configuration>
>     <property>
>         <name>fs.defaultFS</name>
>         <value>hdfs://las1:9000</value>
>     </property>
>     <property>
>         <name>hadoop.tmp.dir</name>
>         <value>/opt/tmp/hadoop</value>
>     </property>
>     <property>
>         <name>hadoop.proxyuser.root.hosts</name>
>         <value>*</value>
>     </property>
>     <property>
>         <name>hadoop.proxyuser.root.groups</name>
>         <value>*</value>
>     </property>
> </configuration>
> ```

```sh
sudo vi /opt/hadoop/etc/hadoop/hdfs-site.xml
```

> ```xml
> <configuration>
>     <property>
>         <name>dfs.replication</name>
>         <value>1</value>
>     </property>
>     <property>
>         <name>dfs.blocksize</name>
>         <value>262144</value>
>     </property>
>     <property>
>         <name>dfs.namenode.fs-limits.min-block-size</name>
>         <value>262144</value>
>     </property>
>     <property>
>         <name>dfs.namenode.handler.count</name>
>         <value>10</value>
>     </property>
> </configuration>
> ```

#### Yarn

```sh
sudo vi /opt/hadoop/etc/hadoop/mapred-site.xml
```

> ```xml
> <configuration>
>     <property>
>         <name>mapreduce.framework.name</name>
>         <value>yarn</value>
>     </property>
>     <property>
>         <name>mapreduce.application.classpath</name>
>         <value>/opt/hadoop/share/hadoop/mapreduce/*:/opt/hadoop/share/hadoop/mapreduce/lib/*</value>
>     </property>
> </configuration>
> ```

```sh
sudo vi /opt/hadoop/etc/hadoop/yarn-site.xml
```

> ```xml
> <configuration>
>     <property>
>         <name>yarn.resourcemanager.hostname</name>
>         <value>las1</value>
>     </property>
>     <property>
>         <name>yarn.nodemanager.aux-services</name>
>         <value>mapreduce_shuffle</value>
>     </property>
>     <property>
>         <name>yarn.nodemanager.resource.detect-hardware-capabilities</name>
>         <value>true</value>
>     </property>
>     <property>
>         <name>yarn.scheduler.maximum-allocation-vcores</name>
>         <value>8</value>
>     </property>
>     <property>
>         <name>yarn.resourcemanager.ha.enabled</name>
>         <value>false</value>
>     </property>
>     <property>
>         <name>yarn.webapp.ui2.enable</name>
>         <value>true</value>
>     </property>
> </configuration>
> ```

#### Nodes

```sh
sudo vi /opt/hadoop/etc/hadoop/workers
```

> ```text
> las1
> las2
> las3
> ```

```sh
for host in las2 las3; do
    for file in /opt/hadoop/etc/hadoop/{hadoop-env.sh,core-site.xml,hdfs-site.xml,mapred-site.xml,yarn-site.xml}; do
        scp "${file}" "${host}:${file}"
    done
done
```

### Run

#### hdfs

```sh
hdfs namenode -format
```

```sh
start-dfs.sh
stop-fds.sh
```

#### yarn

```sh
start-yarn.sh
stop-yarn.sh
```

### Usage

#### hdfs

```sh
hdfs dfs -ls /
hdfs dfs -mkdir -p /user/root
hdfs dfs -put file.dat
hdfs dfs -cat /user/root/file.dat
hdfs dfs -rm file.dat
```

```sh
curl http://las1:9870/
```

#### Clear hdfs data

```sh
for host in las1 las2 las3; do
    ssh "${host}" "rm -rf /opt/tmp/hadoop/dfs/*"
done
```

#### yarn

```sh
curl http://las1:8088/
curl http://las1:8088/ui2/
```

```sh
yarn jar hadoop-wc-1.0.0-SNAPSHOT.jar
```

## 2.10.1

```sh
export ver="2.10.1"
```

### Config

```sh
sudo vi /opt/hadoop/etc/hadoop/slaves
```

> ```text
> las1
> las2
> las3
> ```
