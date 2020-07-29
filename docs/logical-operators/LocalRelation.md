title: LocalRelation

# LocalRelation Leaf Logical Operator

`LocalRelation` is a <<spark-sql-LogicalPlan-LeafNode.md#, leaf logical operator>> that represents a scan over local collections (and allow for optimizations so functions like `collect` or `take` can be executed locally on the driver and with no executors).

`LocalRelation` is <<creating-instance, created>> (using <<apply, apply>>, <<fromExternalRows, fromExternalRows>>, and <<fromProduct, fromProduct>> factory methods) when:

* [ResolveInlineTables](../logical-analysis-rules/ResolveInlineTables.md) logical resolution rule is executed (and [converts an UnresolvedInlineTable](../logical-analysis-rules/ResolveInlineTables.md#convert))

* [PruneFilters](../Optimizer.md#PruneFilters), [ConvertToLocalRelation](../Optimizer.md#ConvertToLocalRelation), and [PropagateEmptyRelation](../Optimizer.md#PropagateEmptyRelation), [OptimizeMetadataOnlyQuery](../Optimizer.md#OptimizeMetadataOnlyQuery) logical optimization rules are executed (applied to an analyzed logical plan)

* <<SparkSession.md#createDataset, SparkSession.createDataset>>, <<SparkSession.md#emptyDataset, SparkSession.emptyDataset>>, <<SparkSession.md#createDataFrame, SparkSession.createDataFrame>> operators are used

* `CatalogImpl` is requested for a <<spark-sql-CatalogImpl.md#makeDataset, Dataset from DefinedByConstructorParams data>>

* `Dataset` is requested for the <<spark-sql-Dataset.md#logicalPlan, analyzed logical plan>> (and executes <<spark-sql-LogicalPlan-Command.md#, Command>> logical operators)

* `StatFunctions` is requested to <<spark-sql-StatFunctions.md#crossTabulate, crossTabulate>> and <<spark-sql-StatFunctions.md#summary, generate summary statistics of Dataset (as DataFrame)>>

NOTE: `Dataset` is <<spark-sql-Dataset.md#isLocal, local>> when the <<spark-sql-Dataset.md#logicalPlan, analyzed logical plan>> is exactly an instance of `LocalRelation`.

[source, scala]
----
val data = Seq(1, 3, 4, 7)
val nums = data.toDF

scala> :type nums
org.apache.spark.sql.DataFrame

val plan = nums.queryExecution.analyzed
scala> println(plan.numberedTreeString)
00 LocalRelation [value#1]

import org.apache.spark.sql.catalyst.plans.logical.LocalRelation
val relation = plan.collect { case r: LocalRelation => r }.head
assert(relation.isInstanceOf[LocalRelation])

val sql = relation.toSQL(inlineTableName = "demo")
assert(sql == "VALUES (1), (3), (4), (7) AS demo(value)")

val stats = relation.computeStats
scala> println(stats)
Statistics(sizeInBytes=48.0 B, hints=none)
----

`LocalRelation` is resolved to <<spark-sql-SparkPlan-LocalTableScanExec.md#, LocalTableScanExec>> leaf physical operator when [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (i.e. plan a <<spark-sql-LogicalPlan.md#, logical plan>> to a <<SparkPlan.md#, physical plan>>).

[source, scala]
----
import org.apache.spark.sql.catalyst.plans.logical.LocalRelation
assert(relation.isInstanceOf[LocalRelation])

scala> :type spark
org.apache.spark.sql.SparkSession

import spark.sessionState.planner.BasicOperators
val localScan = BasicOperators(relation).head

import org.apache.spark.sql.execution.LocalTableScanExec
assert(localScan.isInstanceOf[LocalTableScanExec])
----

[[computeStats]]
When requested for <<spark-sql-LogicalPlan-LeafNode.md#computeStats, statistics>>, `LocalRelation` takes the size of the objects in a single row (per the <<output, output>> schema) and multiplies it by the number of rows (in the <<data, data>>).

=== [[creating-instance]] Creating LocalRelation Instance

`LocalRelation` takes the following to be created:

* [[output]] Output schema spark-sql-Expression-Attribute.md[attributes]
* [[data]] Collection of spark-sql-InternalRow.md[internal binary rows]
* [[isStreaming]] `isStreaming` flag that indicates whether the <<data, data>> comes from a streaming source (default: `false`)

While being created, `LocalRelation` makes sure that the <<output, output attributes>> are all <<expressions/Expression.md#resolved, resolved>> or throws an `IllegalArgumentException`:

```
Unresolved attributes found when constructing LocalRelation.
```

=== [[apply]] Creating LocalRelation -- `apply` Object Method

[source, scala]
----
apply(output: Attribute*): LocalRelation
apply(
  output1: StructField,
  output: StructField*): LocalRelation
----

`apply`...FIXME

NOTE: `apply` is used when...FIXME

=== [[fromExternalRows]] Creating LocalRelation -- `fromExternalRows` Object Method

[source, scala]
----
fromExternalRows(
  output: Seq[Attribute],
  data: Seq[Row]): LocalRelation
----

`fromExternalRows`...FIXME

NOTE: `fromExternalRows` is used when...FIXME

=== [[fromProduct]] Creating LocalRelation -- `fromProduct` Object Method

[source, scala]
----
fromProduct(
  output: Seq[Attribute],
  data: Seq[Product]): LocalRelation
----

`fromProduct`...FIXME

NOTE: `fromProduct` is used when...FIXME

=== [[toSQL]] Generating SQL Statement -- `toSQL` Method

[source, scala]
----
toSQL(inlineTableName: String): String
----

`toSQL` generates a SQL statement of the format:

```
VALUES [data] AS [inlineTableName]([names])
```

`toSQL` throws an `AssertionError` for the <<data, data>> empty.

NOTE: `toSQL` does not _seem_ to be used at all.
