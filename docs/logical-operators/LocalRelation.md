# LocalRelation Leaf Logical Operator

`LocalRelation` is a [leaf logical operator](LeafNode.md) that represents a scan over local collections (and so allows for optimizations for functions like `collect` or `take` to be executed locally on the driver with no executors).

## Creating Instance

`LocalRelation` takes the following to be created:

* <span id="output"> Output Schema [Attribute](../expressions/Attribute.md)s
* <span id="data"> Data ([InternalRow](../InternalRow.md)s)
* [isStreaming](#isStreaming) flag

While created, `LocalRelation` asserts that the [output](#output) attributes are all [resolved](../expressions/Expression.md#resolved) or throws an `IllegalArgumentException`:

```text
Unresolved attributes found when constructing LocalRelation.
```

`LocalRelation` can be created using [apply](#apply), [fromExternalRows](#fromExternalRows), and [fromProduct](#fromProduct) factory methods.

## <span id="isStreaming"> isStreaming Flag

```scala
isStreaming: Boolean
```

`isStreaming` is part of the [LogicalPlan](LogicalPlan.md#isStreaming) abstraction.

`isStreaming` can be given when `LocalRelation` is [created](#creating-instance).

`isStreaming` is `false` by default.

## <span id="MultiInstanceRelation"> MultiInstanceRelation

`LocalRelation` is a [MultiInstanceRelation](MultiInstanceRelation.md).

## Local Datasets

`Dataset` is [local](../Dataset.md#isLocal) when the [analyzed logical plan](../Dataset.md#logicalPlan) is a `LocalRelation`.

```text
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
```

## Execution Planning

`LocalRelation` is resolved to [LocalTableScanExec](../physical-operators/LocalTableScanExec.md) leaf physical operator by [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy.

```text
import org.apache.spark.sql.catalyst.plans.logical.LocalRelation
assert(relation.isInstanceOf[LocalRelation])

scala> :type spark
org.apache.spark.sql.SparkSession

import spark.sessionState.planner.BasicOperators
val localScan = BasicOperators(relation).head

import org.apache.spark.sql.execution.LocalTableScanExec
assert(localScan.isInstanceOf[LocalTableScanExec])
```

## <span id="computeStats"> Statistics

```scala
computeStats(): Statistics
```

`computeStats` is part of the [LeafNode](LeafNode.md#computeStats) abstraction.

`computeStats` is the size of the objects in a single row (per the [output](#output) schema) and multiplies it by the number of rows (in the [data](#data)).

## <span id="toSQL"> SQL Representation

```scala
toSQL(
  inlineTableName: String): String
```

`toSQL` generates a SQL statement of the format:

```text
VALUES [data] AS [inlineTableName]([names])
```

!!! note
    `toSQL` does not _seem_ to be used.

## Demo

```scala
import org.apache.spark.sql.catalyst.plans.logical.LocalRelation
import org.apache.spark.sql.Row
import org.apache.spark.sql.catalyst.expressions.AttributeReference
import org.apache.spark.sql.types.IntegerType
```

```scala
val relation = LocalRelation.fromExternalRows(
  output = Seq(AttributeReference("id", IntegerType)()),
  data = Seq(Row(1)))
```
