# TPC

## TPC-H 3.0.1

### CentOS 7.9

首先安装编译工具链, 用于编译 dbgen, qgen

```sh
yum install gcc make
```

编译

```sh
cd dbgen/
cp makefile.suite Makefile
```

```sh
vi Makefile
```

> ```make
> CC = gcc
> DATABASE = SQLSERVER
> MACHINE = LINUX
> WORKLOAD = TPCH
> ```

```sh
make
```

编译以后生成可执行文件 dbgen, qgen

#### dbgen

dbgen 用于生成数据

```sh
./dbgen -vf -s 0.1 -T L
```

* `-s` 参数设置规模因子，默认为 `1`, 表示生成 1GB 数据
* `-T L` 表示只生成 lineitem 表的数据，如果不指定则生成所有表数据

生成 CSV 格式的数据，文件名为 `lineitem.tbl`, 分隔符为 `|`, 每行末尾的分隔符可能多余，先去掉

```sh
sed -i -e 's/|$//g' lineitem.tbl
```

#### qgen

```sh
DSS_QUERY=queries/ ./qgen -v -s 0.1
```
