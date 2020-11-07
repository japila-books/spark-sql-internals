# Dynamic Partition Inserts

**Partitioning** uses **partitioning columns** to divide a dataset into smaller chunks (based on the values of certain columns) that will be written into separate directories.

With a partitioned dataset, Spark SQL can load only the parts (partitions) that are really needed (and avoid doing filtering out unnecessary data on JVM). That leads to faster load time and more efficient memory consumption which gives a better performance overall.

With a partitioned dataset, Spark SQL can also be executed over different subsets (directories) in parallel at the same time.

```text
spark.range(10)
  .withColumn("p1", 'id % 2)
  .write
  .mode("overwrite")
  .partitionBy("p1")
  .saveAsTable("partitioned_table")
```

**Dynamic Partition Inserts** is a feature of Spark SQL that allows for executing `INSERT OVERWRITE TABLE` SQL statements over partitioned [HadoopFsRelations](HadoopFsRelation.md) that limits what partitions are deleted to overwrite the partitioned table (and its partitions) with new data.

[[dynamic-partitions]]
*Dynamic partitions* are the partition columns that have no values defined explicitly in the PARTITION clause of <<spark-sql-AstBuilder.md#visitInsertOverwriteTable, INSERT OVERWRITE TABLE>> SQL statements (in the `partitionSpec` part).

[[static-partitions]]
*Static partitions* are the partition columns that have values defined explicitly in the PARTITION clause of <<spark-sql-AstBuilder.md#visitInsertOverwriteTable, INSERT OVERWRITE TABLE>> SQL statements (in the `partitionSpec` part).

```
// Borrowed from https://medium.com/@anuvrat/writing-into-dynamic-partitions-using-spark-2e2b818a007a
// Note day dynamic partition
INSERT OVERWRITE TABLE stats
PARTITION(country = 'US', year = 2017, month = 3, day)
SELECT ad, SUM(impressions), SUM(clicks), log_day
FROM impression_logs
GROUP BY ad;
```

NOTE: `INSERT OVERWRITE TABLE` SQL statement is translated into <<InsertIntoTable.md#, InsertIntoTable>> logical operator.

Dynamic Partition Inserts is only supported in SQL mode (for <<spark-sql-AstBuilder.md#visitInsertOverwriteTable, INSERT OVERWRITE TABLE>> SQL statements).

Dynamic Partition Inserts [is not supported](logical-analysis-rules/PreWriteCheck.md#apply-InsertableRelation) for non-file-based data sources ([InsertableRelations](spark-sql-InsertableRelation.md)s).

With Dynamic Partition Inserts, the behaviour of `OVERWRITE` keyword is controlled by [spark.sql.sources.partitionOverwriteMode](configuration-properties.md#spark.sql.sources.partitionOverwriteMode) configuration property. The property controls whether Spark should delete **all** the partitions that match the partition specification regardless of whether there is data to be written to or not or delete only those partitions that will have data written into.

When the `dynamic` overwrite mode is enabled Spark will only delete the partitions for which it has data to be written to. All the other partitions remain intact.

From the [Writing Into Dynamic Partitions Using Spark](https://medium.com/@anuvrat/writing-into-dynamic-partitions-using-spark-2e2b818a007a):

> Spark now writes data partitioned just as Hive would — which means only the partitions that are touched by the INSERT query get overwritten and the others are not touched.
