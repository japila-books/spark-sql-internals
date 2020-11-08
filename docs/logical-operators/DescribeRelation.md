# DescribeRelation Logical Command

`DescribeRelation` is a [logical command](Command.md) that represents [DESCRIBE TABLE](../sql/AstBuilder.md#visitDescribeRelation) SQL statement.

## Demo

```scala
val table = "four"
spark.range(4).writeTo(table).create
val stmt = s"DESC TABLE EXTENDED $table"
```

```text
scala> sql(stmt).show(truncate = false)
+----------------------------+--------------------------------------------------------------+-------+
|col_name                    |data_type                                                     |comment|
+----------------------------+--------------------------------------------------------------+-------+
|id                          |bigint                                                        |null   |
|                            |                                                              |       |
|# Detailed Table Information|                                                              |       |
|Database                    |default                                                       |       |
|Table                       |four                                                          |       |
|Owner                       |jacek                                                         |       |
|Created Time                |Sun Nov 08 11:49:04 CET 2020                                  |       |
|Last Access                 |UNKNOWN                                                       |       |
|Created By                  |Spark 3.0.1                                                   |       |
|Type                        |MANAGED                                                       |       |
|Provider                    |parquet                                                       |       |
|Statistics                  |2125 bytes                                                    |       |
|Location                    |file:/Users/jacek/dev/oss/spark/spark-warehouse/four          |       |
|Serde Library               |org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe   |       |
|InputFormat                 |org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat |       |
|OutputFormat                |org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat|       |
+----------------------------+--------------------------------------------------------------+-------+
```

## Creating Instance

`DescribeRelation` takes the following to be created:

* <span id="relation"> [LogicalPlan](LogicalPlan.md)
* <span id="partitionSpec"> Partition Specification (`Map[String, String]`)
* <span id="isExtended"> `isExtended` flag

`DescribeRelation` is created when `AstBuilder` is requested to [parse DESCRIBE TABLE statement](../sql/AstBuilder.md#visitDescribeRelation).

## Analysis

`DescribeRelation` is resolved to a [DescribeTableCommand](DescribeTableCommand.md) logical operator with the following logical relations:

* `ResolvedTable` leaf logical operators with [V1Table](../connector/V1Table.md) tables
* `ResolvedView` leaf logical operator

`DescribeRelation` is resolved by [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical analysis rule.

## Execution Planning

`DescribeRelation` (with a `ResolvedTable` leaf logical operator) is planned to [DescribeTableExec](../physical-operators/DescribeTableExec.md) physical command.

`DescribeRelation` is planned by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy.
