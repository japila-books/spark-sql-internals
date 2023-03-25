# JDBC Connector

Spark SQL supports loading data from tables using JDBC.

Spark developers use [DataFrameReader.jdbc](../DataFrameReader.md#jdbc) to load data from an external table using JDBC.

```scala
val table = spark.read.jdbc(url, table, properties)

// Alternatively
val table = spark.read.format("jdbc").options(...).load(...)
```

These one-liners create a [DataFrame](../DataFrame.md) that represents the distributed process of loading data from a database and a table (with additional properties).
