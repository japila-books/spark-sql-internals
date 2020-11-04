# WriteSupport

`WriteSupport` is the <<contract, abstraction>> of ["writable" data sources](#implementations) in the [DataSource V2](new-and-noteworthy/datasource-v2.md) that can <<createWriter, create a DataSourceWriter>> for writing data out.

[[contract]]
[[createWriter]]
`WriteSupport` defines a single `createWriter` method that creates an optional <<spark-sql-DataSourceWriter.md#, DataSourceWriter>> per [SaveMode](DataFrameWriter.md#SaveMode) (and can create no `DataSourceWriter` when not needed per mode)

```java
Optional<DataSourceWriter> createWriter(
  String writeUUID,
  StructType schema,
  SaveMode mode,
  DataSourceOptions options)
```

`createWriter` is used when:

* `DataFrameWriter` is requested to [save a DataFrame to a data source](DataFrameWriter.md#save) (for [DataSourceV2](spark-sql-DataSourceV2.md) data sources with [WriteSupport](#WriteSupport))

* `DataSourceV2Relation` leaf logical operator is requested to <<spark-sql-LogicalPlan-DataSourceV2Relation.md#newWriter, create a DataSourceWriter>> (indirectly via <<spark-sql-LogicalPlan-DataSourceV2Relation.md#createWriter, createWriter>> implicit method)

[source, scala]
----
// FIXME: Demo
// df.write.format(...) that is DataSourceV2 and WriteSupport
----

[[implementations]]
NOTE: There are no production implementations of the <<contract, WriteSupport Contract>> in Spark SQL yet.
