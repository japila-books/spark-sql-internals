---
title: Using JDBC Data Source to Access PostgreSQL
hide:
  - navigation
---

# Demo: Using JDBC Data Source to Access PostgreSQL

This demo shows how to use [JDBC Data Source](../jdbc/index.md) to load data from PostgreSQL. These steps should be equally applicable to any relational database that allows access using a JDBC driver.

## Start Postgres Instance

```text
docker run --name postgres-demo -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -d postgres
```

```text
docker ps
```

## Download JDBC Driver

Download the most current version of [PostgreSQL JDBC Driver](https://jdbc.postgresql.org/download.html#current) (e.g. PostgreSQL JDBC 4.2 Driver, 42.2.19).

Use an environment variable for the path of the jar file.

```text
JDBC_DRIVER=/my/path/postgresql-42.2.11.jar
```

## spark-shell

```text
$SPARK_HOME/bin/spark-shell --version
```

```text
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 3.1.1
      /_/

Using Scala version 2.12.10, OpenJDK 64-Bit Server VM, 11.0.10
Branch HEAD
Compiled by user ubuntu on 2021-02-22T01:33:19Z
Revision 1d550c4e90275ab418b9161925049239227f3dc9
Url https://github.com/apache/spark
Type --help for more information.
```

```text
$SPARK_HOME/bin/spark-shell --driver-class-path $JDBC_DRIVER --jars $JDBC_DRIVER
```

```text
val sampledata = spark.range(5)
sampledata.write
  .format("jdbc")
  .option("url", "jdbc:postgresql:postgres")
  .option("dbtable", "nums")
  .option("user", "postgres")
  .option("password", "mysecretpassword")
  .save
```

```text
val nums = spark.read
  .format("jdbc")
  .option("url", "jdbc:postgresql:postgres")
  .option("dbtable", "nums")
  .option("user", "postgres")
  .option("password", "mysecretpassword")
  .load
```

```text
nums.show
```

## Clean Up

```text
docker stop postgres-demo
```

```text
docker stop postgres-demo
```

_That's it. Congratulations!_
