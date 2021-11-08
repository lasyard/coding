# hive

## 3.1.2

```sh
export ver="3.1.2"
```

### Download

```sh
wget https://dlcdn.apache.org/hive/hive-${ver}/apache-hive-${ver}-bin.tar.gz --no-check-certificate
```

Install to `/opt`.

```sh
# for metastore
sudo mkdir -p /opt/tmp/hive
```

### Env

```sh
echo "export HIVE_HOME=\"/opt/hive\"" | sudo tee -a /etc/profile.d/hive.sh
```

### Config

```sh
vi /opt/hive/conf/hive-site.xml
```

> ```xml
> <configuration>
>     <property>
>         <name>javax.jdo.option.ConnectionURL</name>
>         <value>jdbc:derby:;databaseName=/opt/tmp/hive/metastore_db;create=true</value>
>     </property>
> </configuration>
> ```

### Run

Create dirs in hadoop

```sh
hadoop fs -mkdir /tmp
hadoop fs -mkdir -p /user/hive/warehouse
```

```sh
schematool -dbType derby -initSchema
```

```sh
hiveserver2
```

### Usage

```sh
beeline
```

In beeline

```sql
!connect jdbc:hive2://localhost:10000
!help
!tables
!close
!quit
```
