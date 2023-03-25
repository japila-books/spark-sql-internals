# RelationConversions PostHoc Logical Evaluation Rule

`RelationConversions` is a HiveSessionStateBuilder.md#postHocResolutionRules[posthoc logical resolution rule] that the HiveSessionStateBuilder.md#analyzer[Hive-specific logical analyzer] uses to <<apply, convert HiveTableRelations>> with Parquet and ORC storage formats.

CAUTION: FIXME Show example of a hive table, e.g. `spark.table(...)`

`RelationConversions` is <<creating-instance, created>> when the HiveSessionStateBuilder.md#analyzer[Hive-specific logical analyzer] is created.

=== [[creating-instance]] Creating RelationConversions Instance

`RelationConversions` takes the following when created:

* [[conf]] [SQLConf](../SQLConf.md)
* [[sessionCatalog]] [Hive-specific session catalog](HiveSessionCatalog.md)

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of the ../catalyst/Rule.md#apply[Rule] contract to execute (apply) a rule on a ../spark-sql-LogicalPlan.md[LogicalPlan].

`apply` traverses the input ../spark-sql-LogicalPlan.md[logical plan] looking for ../InsertIntoTable.md[InsertIntoTables] (over a HiveTableRelation.md[HiveTableRelation]) or HiveTableRelation.md[HiveTableRelation] logical operators:

[[apply-InsertIntoTable]]
* For an ../InsertIntoTable.md[InsertIntoTable] over a HiveTableRelation.md[HiveTableRelation] that is HiveTableRelation.md#isPartitioned[non-partitioned] and <<isConvertible, is convertible>>, `apply` creates a new `InsertIntoTable` with the `HiveTableRelation` <<convert, converted to a LogicalRelation>>.

[[apply-HiveTableRelation]]
* For a `HiveTableRelation` logical operator alone `apply`...FIXME

=== [[isConvertible]] Does Table Use Parquet or ORC SerDe? -- `isConvertible` Internal Method

[source, scala]
----
isConvertible(
  relation: HiveTableRelation): Boolean
----

`isConvertible` is positive when the input HiveTableRelation.md#tableMeta[HiveTableRelation] is a parquet or ORC table (and corresponding SQL properties are enabled).

Internally, `isConvertible` takes the Hive SerDe of the table (from HiveTableRelation.md#tableMeta[table metadata]) if available or assumes no SerDe.

`isConvertible` is turned on when either condition holds:

* The Hive SerDe is `parquet` (aka _parquet table_) and [spark.sql.hive.convertMetastoreParquet](configuration-properties.md#spark.sql.hive.convertMetastoreParquet) configuration property is enabled

* The Hive SerDe is `orc` (aka _orc table_) and [spark.sql.hive.convertMetastoreOrc](configuration-properties.md#spark.sql.hive.convertMetastoreOrc) configuration property is enabled

NOTE: `isConvertible` is used when `RelationConversions` is <<apply, executed>>.

=== [[convert]] Converting HiveTableRelation to HadoopFsRelation -- `convert` Internal Method

[source, scala]
----
convert(
  relation: HiveTableRelation): LogicalRelation
----

`convert` branches based on the SerDe of (the storage format of) the input [HiveTableRelation](HiveTableRelation.md) logical operator.

For Hive tables in parquet format, `convert` creates options with one extra `mergeSchema` per [spark.sql.hive.convertMetastoreParquet.mergeSchema](configuration-properties.md#spark.sql.hive.convertMetastoreParquet.mergeSchema) configuration property and requests the [HiveMetastoreCatalog](HiveSessionCatalog.md#metastoreCatalog) to [convert a HiveTableRelation to a LogicalRelation](HiveMetastoreCatalog.md#convertToLogicalRelation) (with [ParquetFileFormat](../parquet/ParquetFileFormat.md)).

For non-`parquet` Hive tables, `convert` assumes ORC format:

* When [spark.sql.orc.impl](../configuration-properties.md#spark.sql.orc.impl) configuration property is `native` (default) `convert` requests `HiveMetastoreCatalog` to HiveMetastoreCatalog.md#convertToLogicalRelation[convert a HiveTableRelation to a LogicalRelation over a HadoopFsRelation] (with `org.apache.spark.sql.execution.datasources.orc.OrcFileFormat` as `fileFormatClass`).

* Otherwise, `convert` requests `HiveMetastoreCatalog` to HiveMetastoreCatalog.md#convertToLogicalRelation[convert a HiveTableRelation to a LogicalRelation over a HadoopFsRelation] (with `org.apache.spark.sql.hive.orc.OrcFileFormat` as `fileFormatClass`).

NOTE: `convert` uses the <<sessionCatalog, HiveSessionCatalog>> to access the [HiveMetastoreCatalog](HiveSessionCatalog.md#metastoreCatalog).

[NOTE]
====
`convert` is used when `RelationConversions` logical evaluation rule is <<apply, executed>> and does the following transformations:

* Transforms an ../InsertIntoTable.md[InsertIntoTable] over a `HiveTableRelation` with a Hive table (i.e. with `hive` provider) that is not partitioned and uses `parquet` or `orc` data storage format

* Transforms an HiveTableRelation.md[HiveTableRelation] with a Hive table (i.e. with `hive` provider) that uses `parquet` or `orc` data storage format
====
