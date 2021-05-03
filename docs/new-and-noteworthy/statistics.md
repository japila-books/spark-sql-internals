# Statistics

[Statistics](../logical-operators/Statistics.md) are supported for the following only:

1. Hive Metastore tables for which `ANALYZE TABLE <tableName> COMPUTE STATISTICS noscan` has been executed
1. [File-based data source tables](../datasources/FileFormat.md) for which the statistics are computed directly on the files of data

## Broadcast Join

Broadcast Join can be automatically selected by the Spark Planner based on the [Statistics](../logical-operators/Statistics.md) and the [spark.sql.autoBroadcastJoinThreshold](../configuration-properties.md#spark.sql.autoBroadcastJoinThreshold) configuration property.


