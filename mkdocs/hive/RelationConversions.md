title: RelationConversions

# RelationConversions PostHoc Logical Evaluation Rule

`RelationConversions` is a link:HiveSessionStateBuilder.adoc#postHocResolutionRules[posthoc logical resolution rule] that the link:HiveSessionStateBuilder.adoc#analyzer[Hive-specific logical analyzer] uses to <<apply, convert HiveTableRelations>> with Parquet and ORC storage formats.

CAUTION: FIXME Show example of a hive table, e.g. `spark.table(...)`

`RelationConversions` is <<creating-instance, created>> when the link:HiveSessionStateBuilder.adoc#analyzer[Hive-specific logical analyzer] is created.

=== [[creating-instance]] Creating RelationConversions Instance

`RelationConversions` takes the following when created:

* [[conf]] link:../spark-sql-SQLConf.adoc[SQLConf]
* [[sessionCatalog]] link:HiveSessionCatalog.adoc[Hive-specific session catalog]

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of the link:../spark-sql-catalyst-Rule.adoc#apply[Rule] contract to execute (apply) a rule on a link:../spark-sql-LogicalPlan.adoc[LogicalPlan].

`apply` traverses the input link:../spark-sql-LogicalPlan.adoc[logical plan] looking for link:../InsertIntoTable.adoc[InsertIntoTables] (over a link:HiveTableRelation.adoc[HiveTableRelation]) or link:HiveTableRelation.adoc[HiveTableRelation] logical operators:

[[apply-InsertIntoTable]]
* For an link:../InsertIntoTable.adoc[InsertIntoTable] over a link:HiveTableRelation.adoc[HiveTableRelation] that is link:HiveTableRelation.adoc#isPartitioned[non-partitioned] and <<isConvertible, is convertible>>, `apply` creates a new `InsertIntoTable` with the `HiveTableRelation` <<convert, converted to a LogicalRelation>>.

[[apply-HiveTableRelation]]
* For a `HiveTableRelation` logical operator alone `apply`...FIXME

=== [[isConvertible]] Does Table Use Parquet or ORC SerDe? -- `isConvertible` Internal Method

[source, scala]
----
isConvertible(
  relation: HiveTableRelation): Boolean
----

`isConvertible` is positive when the input link:HiveTableRelation.adoc#tableMeta[HiveTableRelation] is a parquet or ORC table (and corresponding SQL properties are enabled).

Internally, `isConvertible` takes the Hive SerDe of the table (from link:HiveTableRelation.adoc#tableMeta[table metadata]) if available or assumes no SerDe.

`isConvertible` is turned on when either condition holds:

* The Hive SerDe is `parquet` (aka _parquet table_) and link:configuration-properties.adoc#spark.sql.hive.convertMetastoreParquet[spark.sql.hive.convertMetastoreParquet] configuration property is enabled (which is by default)

* The Hive SerDe is `orc` (aka _orc table_) and link:../spark-sql-properties.adoc#spark.sql.hive.convertMetastoreOrc[spark.sql.hive.convertMetastoreOrc] internal configuration property is enabled (which is by default)

NOTE: `isConvertible` is used when `RelationConversions` is <<apply, executed>>.

=== [[convert]] Converting HiveTableRelation to HadoopFsRelation -- `convert` Internal Method

[source, scala]
----
convert(
  relation: HiveTableRelation): LogicalRelation
----

`convert` branches based on the SerDe of (the storage format of) the input link:HiveTableRelation.adoc[HiveTableRelation] logical operator.

For Hive tables in parquet format, `convert` creates options with one extra `mergeSchema` per link:configuration-properties.adoc#spark.sql.hive.convertMetastoreParquet.mergeSchema[spark.sql.hive.convertMetastoreParquet.mergeSchema] configuration property and requests the link:HiveSessionCatalog.adoc#metastoreCatalog[HiveMetastoreCatalog] to link:HiveMetastoreCatalog.adoc#convertToLogicalRelation[convert a HiveTableRelation to a LogicalRelation] (with link:../spark-sql-ParquetFileFormat.adoc[ParquetFileFormat]).

For non-`parquet` Hive tables, `convert` assumes ORC format:

* When link:../spark-sql-properties.adoc#spark.sql.orc.impl[spark.sql.orc.impl] configuration property is `native` (default) `convert` requests `HiveMetastoreCatalog` to link:HiveMetastoreCatalog.adoc#convertToLogicalRelation[convert a HiveTableRelation to a LogicalRelation over a HadoopFsRelation] (with `org.apache.spark.sql.execution.datasources.orc.OrcFileFormat` as `fileFormatClass`).

* Otherwise, `convert` requests `HiveMetastoreCatalog` to link:HiveMetastoreCatalog.adoc#convertToLogicalRelation[convert a HiveTableRelation to a LogicalRelation over a HadoopFsRelation] (with `org.apache.spark.sql.hive.orc.OrcFileFormat` as `fileFormatClass`).

NOTE: `convert` uses the <<sessionCatalog, HiveSessionCatalog>> to access the link:HiveSessionCatalog.adoc#metastoreCatalog[HiveMetastoreCatalog].

[NOTE]
====
`convert` is used when `RelationConversions` logical evaluation rule is <<apply, executed>> and does the following transformations:

* Transforms an link:../InsertIntoTable.adoc[InsertIntoTable] over a `HiveTableRelation` with a Hive table (i.e. with `hive` provider) that is not partitioned and uses `parquet` or `orc` data storage format

* Transforms an link:HiveTableRelation.adoc[HiveTableRelation] with a Hive table (i.e. with `hive` provider) that uses `parquet` or `orc` data storage format
====
