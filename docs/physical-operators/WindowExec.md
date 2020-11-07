# WindowExec Unary Physical Operator

`WindowExec` is a [unary physical operator](UnaryExecNode.md) for **window aggregation execution** (and represents [Window](../logical-operators/Window.md) unary logical operator at execution time).

`WindowExec` is <<creating-instance, created>> exclusively when [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy resolves a <<Window.md#, Window>> unary logical operator.

[source, scala]
----
// arguably the most trivial example
// just a dataset of 3 rows per group
// to demo how partitions and frames work
// note the rows per groups are not consecutive (in the middle)
val metrics = Seq(
  (0, 0, 0), (1, 0, 1), (2, 5, 2), (3, 0, 3), (4, 0, 1), (5, 5, 3), (6, 5, 0)
).toDF("id", "device", "level")
scala> metrics.show
+---+------+-----+
| id|device|level|
+---+------+-----+
|  0|     0|    0|
|  1|     0|    1|
|  2|     5|    2|  // <-- this row for device 5 is among the rows of device 0
|  3|     0|    3|  // <-- as above but for device 0
|  4|     0|    1|  // <-- almost as above but there is a group of two rows for device 0
|  5|     5|    3|
|  6|     5|    0|
+---+------+-----+

// create windows of rows to use window aggregate function over every window
import org.apache.spark.sql.expressions.Window
val rangeWithTwoDevicesById = Window.
  partitionBy('device).
  orderBy('id).
  rangeBetween(start = -1, end = Window.currentRow) // <-- demo rangeBetween first
val sumOverRange = metrics.withColumn("sum", sum('level) over rangeWithTwoDevicesById)

// Logical plan with Window unary logical operator
val optimizedPlan = sumOverRange.queryExecution.optimizedPlan
scala> println(optimizedPlan)
Window [sum(cast(level#9 as bigint)) windowspecdefinition(device#8, id#7 ASC NULLS FIRST, RANGE BETWEEN 1 PRECEDING AND CURRENT ROW) AS sum#15L], [device#8], [id#7 ASC NULLS FIRST]
+- LocalRelation [id#7, device#8, level#9]

// Physical plan with WindowExec unary physical operator (shown as Window)
scala> sumOverRange.explain
== Physical Plan ==
Window [sum(cast(level#9 as bigint)) windowspecdefinition(device#8, id#7 ASC NULLS FIRST, RANGE BETWEEN 1 PRECEDING AND CURRENT ROW) AS sum#15L], [device#8], [id#7 ASC NULLS FIRST]
+- *Sort [device#8 ASC NULLS FIRST, id#7 ASC NULLS FIRST], false, 0
   +- Exchange hashpartitioning(device#8, 200)
      +- LocalTableScan [id#7, device#8, level#9]

// Going fairly low-level...you've been warned

val plan = sumOverRange.queryExecution.executedPlan
import org.apache.spark.sql.execution.window.WindowExec
val we = plan.asInstanceOf[WindowExec]
val windowRDD = we.execute()
scala> :type windowRDD
org.apache.spark.rdd.RDD[org.apache.spark.sql.catalyst.InternalRow]

scala> windowRDD.toDebugString
res0: String =
(200) MapPartitionsRDD[5] at execute at <console>:35 []
  |   MapPartitionsRDD[4] at execute at <console>:35 []
  |   ShuffledRowRDD[3] at execute at <console>:35 []
  +-(7) MapPartitionsRDD[2] at execute at <console>:35 []
     |  MapPartitionsRDD[1] at execute at <console>:35 []
     |  ParallelCollectionRDD[0] at execute at <console>:35 []

// no computation on the source dataset has really occurred
// Let's trigger a RDD action
scala> windowRDD.first
res0: org.apache.spark.sql.catalyst.InternalRow = [0,2,5,2,2]

scala> windowRDD.foreach(println)
[0,2,5,2,2]
[0,0,0,0,0]
[0,5,5,3,3]
[0,6,5,0,3]
[0,1,0,1,1]
[0,3,0,3,3]
[0,4,0,1,4]

scala> sumOverRange.show
+---+------+-----+---+
| id|device|level|sum|
+---+------+-----+---+
|  2|     5|    2|  2|
|  5|     5|    3|  3|
|  6|     5|    0|  3|
|  0|     0|    0|  0|
|  1|     0|    1|  1|
|  3|     0|    3|  3|
|  4|     0|    1|  4|
+---+------+-----+---+

// use rowsBetween
val rowsWithTwoDevicesById = Window.
  partitionBy('device).
  orderBy('id).
  rowsBetween(start = -1, end = Window.currentRow)
val sumOverRows = metrics.withColumn("sum", sum('level) over rowsWithTwoDevicesById)

// let's see the result first to have them close
// and compare row- vs range-based windows
scala> sumOverRows.show
+---+------+-----+---+
| id|device|level|sum|
+---+------+-----+---+
|  2|     5|    2|  2|
|  5|     5|    3|  5| <-- a difference
|  6|     5|    0|  3|
|  0|     0|    0|  0|
|  1|     0|    1|  1|
|  3|     0|    3|  4| <-- another difference
|  4|     0|    1|  4|
+---+------+-----+---+

val rowsOptimizedPlan = sumOverRows.queryExecution.optimizedPlan
scala> println(rowsOptimizedPlan)
Window [sum(cast(level#901 as bigint)) windowspecdefinition(device#900, id#899 ASC NULLS FIRST, ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS sum#1458L], [device#900], [id#899 ASC NULLS FIRST]
+- LocalRelation [id#899, device#900, level#901]

scala> sumOverRows.explain
== Physical Plan ==
Window [sum(cast(level#901 as bigint)) windowspecdefinition(device#900, id#899 ASC NULLS FIRST, ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS sum#1458L], [device#900], [id#899 ASC NULLS FIRST]
+- *Sort [device#900 ASC NULLS FIRST, id#899 ASC NULLS FIRST], false, 0
   +- Exchange hashpartitioning(device#900, 200)
      +- LocalTableScan [id#899, device#900, level#901]
----

[source, scala]
----
// a more involved example
val dataset = spark.range(start = 0, end = 13, step = 1, numPartitions = 4)

import org.apache.spark.sql.expressions.Window
val groupsOrderById = Window.partitionBy('group).rangeBetween(-2, Window.currentRow).orderBy('id)
val query = dataset.
  withColumn("group", 'id % 4).
  select('*, sum('id) over groupsOrderById as "sum")

scala> query.explain
== Physical Plan ==
Window [sum(id#25L) windowspecdefinition(group#244L, id#25L ASC NULLS FIRST, RANGE BETWEEN 2 PRECEDING AND CURRENT ROW) AS sum#249L], [group#244L], [id#25L ASC NULLS FIRST]
+- *Sort [group#244L ASC NULLS FIRST, id#25L ASC NULLS FIRST], false, 0
   +- Exchange hashpartitioning(group#244L, 200)
      +- *Project [id#25L, (id#25L % 4) AS group#244L]
         +- *Range (0, 13, step=1, splits=4)

val plan = query.queryExecution.executedPlan
import org.apache.spark.sql.execution.window.WindowExec
val we = plan.asInstanceOf[WindowExec]
----

.WindowExec in web UI (Details for Query)
image::images/spark-sql-WindowExec-webui-query-details.png[align="center"]

[[output]]
The catalyst/QueryPlan.md#output[output schema] of `WindowExec` are the spark-sql-Expression-Attribute.md[attributes] of the <<child, child>> physical operator and the <<windowExpression, window expressions>>.

[source, scala]
----
// the whole schema is as follows
val schema = query.queryExecution.executedPlan.output.toStructType
scala> println(schema.treeString)
root
 |-- id: long (nullable = false)
 |-- group: long (nullable = true)
 |-- sum: long (nullable = true)

// Let's see ourselves how the schema is made up of

scala> :type we
org.apache.spark.sql.execution.window.WindowExec

// child's output
scala> println(we.child.output.toStructType.treeString)
root
 |-- id: long (nullable = false)
 |-- group: long (nullable = true)

// window expressions' output
val weExprSchema = we.windowExpression.map(_.toAttribute).toStructType
scala> println(weExprSchema.treeString)
root
 |-- sum: long (nullable = true)
----

[[requiredChildDistribution]]
The <<SparkPlan.md#requiredChildDistribution, required child output distribution>> of a `WindowExec` operator is one of the following:

* [AllTuples](AllTuples.md) when the <<partitionSpec, window partition specification expressions>> is empty

* [ClusteredDistribution](ClusteredDistribution.md) (with the <<partitionSpec, window partition specification expressions>>) with the <<partitionSpec, partition specification>> specified

If no window partition specification is specified, `WindowExec` prints out the following WARN message to the logs:

```
WARN WindowExec: No Partition Defined for Window operation! Moving all data to a single partition, this can cause serious performance degradation.
```

[[logging]]
[TIP]
====
Enable `WARN` logging level for `org.apache.spark.sql.execution.WindowExec` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.execution.WindowExec=WARN
```

Refer to <<spark-logging.md#, Logging>>.
====

=== [[doExecute]] Executing Physical Operator (Generating RDD[InternalRow]) -- `doExecute` Method

[source, scala]
----
doExecute(): RDD[InternalRow]
----

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute` SparkPlan.md#execute[executes] the single <<child, child>> physical operator and spark-rdd-transformations.md#mapPartitions[maps over partitions] using a custom `Iterator[InternalRow]`.

NOTE: When executed, `doExecute` creates a `MapPartitionsRDD` with the `child` physical operator's `RDD[InternalRow]`.

```text
scala> :type we
org.apache.spark.sql.execution.window.WindowExec

val windowRDD = we.execute
scala> :type windowRDD
org.apache.spark.rdd.RDD[org.apache.spark.sql.catalyst.InternalRow]

scala> println(windowRDD.toDebugString)
(200) MapPartitionsRDD[5] at execute at <console>:35 []
  |   MapPartitionsRDD[4] at execute at <console>:35 []
  |   ShuffledRowRDD[3] at execute at <console>:35 []
  +-(7) MapPartitionsRDD[2] at execute at <console>:35 []
     |  MapPartitionsRDD[1] at execute at <console>:35 []
     |  ParallelCollectionRDD[0] at execute at <console>:35 []
```

Internally, `doExecute` first takes spark-sql-Expression-WindowExpression.md[WindowExpressions] and their spark-sql-WindowFunctionFrame.md[WindowFunctionFrame] factory functions (from <<windowFrameExpressionFactoryPairs, window frame factories>>) followed by SparkPlan.md#execute[executing] the single `child` physical operator and mapping over partitions (using `RDD.mapPartitions` operator).

`doExecute` creates an `Iterator[InternalRow]` (of UnsafeRow.md[UnsafeRow] exactly).

==== [[iterator]] Mapping Over UnsafeRows per Partition -- `Iterator[InternalRow]`

[[result]]
When created, `Iterator[InternalRow]` first creates two spark-sql-UnsafeProjection.md[UnsafeProjection] conversion functions (to convert `InternalRows` to `UnsafeRows`) as <<createResultProjection, result>> and `grouping`.

NOTE: <<grouping, grouping>> conversion function is spark-sql-GenerateUnsafeProjection.md#create[created] for <<partitionSpec, window partition specifications expressions>> and used exclusively to create <<nextGroup, nextGroup>> when `Iterator[InternalRow]` is requested <<fetchNextRow, next row>>.

[TIP]
====
Enable `DEBUG` logging level for `org.apache.spark.sql.catalyst.expressions.codegen.CodeGenerator` logger to see the code generated for `grouping` conversion function.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.catalyst.expressions.codegen.CodeGenerator=DEBUG
```

Refer to spark-logging.md[Logging].
====

`Iterator[InternalRow]` then <<fetchNextRow, fetches the first row>> from the upstream RDD and initializes `nextRow` and `nextGroup` UnsafeRow.md[UnsafeRows].

[[nextGroup]]
NOTE: `nextGroup` is the result of converting `nextRow` using <<grouping, grouping>> conversion function.

[[buffer]]
`doExecute` creates a [ExternalAppendOnlyUnsafeRowArray](../spark-sql-ExternalAppendOnlyUnsafeRowArray.md) buffer using [spark.sql.windowExec.buffer.spill.threshold](../configuration-properties.md#spark.sql.windowExec.buffer.spill.threshold) configuration property as the threshold for the number of rows buffered.

[[windowFunctionResult]]
`doExecute` creates a `SpecificInternalRow` for the window function result (as `windowFunctionResult`).

NOTE: `SpecificInternalRow` is also used in the generated code for the `UnsafeProjection` for the result.

[[frames]]
`doExecute` takes the <<windowFrameExpressionFactoryPairs, window frame factories>> and generates spark-sql-WindowFunctionFrame.md[WindowFunctionFrame] per factory (using the <<windowFunctionResult, SpecificInternalRow>> created earlier).

CAUTION: FIXME

NOTE: spark-sql-ExternalAppendOnlyUnsafeRowArray.md[ExternalAppendOnlyUnsafeRowArray] is used to collect `UnsafeRow` objects from the child's partitions (one partition per buffer and up to `spark.sql.windowExec.buffer.spill.threshold`).

==== [[next]] `next` Method

[source, scala]
----
override final def next(): InternalRow
----

NOTE: `next` is part of Scala's http://www.scala-lang.org/api/2.11.11/#scala.collection.Iterator[scala.collection.Iterator] interface that returns the next element and discards it from the iterator.

`next` method of the final `Iterator` is...FIXME

`next` first <<fetchNextPartition, fetches a new partition>>, but only when...FIXME

NOTE: `next` loads all the rows in `nextGroup`.

CAUTION: FIXME What's `nextGroup`?

`next` takes one UnsafeRow.md[UnsafeRow] from `bufferIterator`.

CAUTION: FIXME `bufferIterator` seems important for the iteration.

`next` then requests every spark-sql-WindowFunctionFrame.md[WindowFunctionFrame] to write the current `rowIndex` and `UnsafeRow`.

CAUTION: FIXME `rowIndex`?

`next` joins the current `UnsafeRow` and `windowFunctionResult` (i.e. takes two `InternalRows` and makes them appear as a single concatenated `InternalRow`).

`next` increments `rowIndex`.

In the end, `next` uses the `UnsafeProjection` function (that was created using <<createResultProjection, createResultProjection>>) and projects the joined `InternalRow` to the result `UnsafeRow`.

==== [[fetchNextPartition]] Fetching All Rows In Partition -- `fetchNextPartition` Internal Method

[source, scala]
----
fetchNextPartition(): Unit
----

`fetchNextPartition` first copies the current <<nextGroup, nextGroup UnsafeRow>> (that was created using <<grouping, grouping>> projection function) and clears the internal <<buffer, buffer>>.

`fetchNextPartition` then collects all `UnsafeRows` for the current `nextGroup` in <<buffer, buffer>>.

With the `buffer` filled in (with `UnsafeRows` per partition), `fetchNextPartition` spark-sql-WindowFunctionFrame.md#prepare[prepares every WindowFunctionFrame function] in <<frames, frames>> one by one (and passing <<buffer, buffer>>).

In the end, `fetchNextPartition` resets `rowIndex` to `0` and requests `buffer` to generate an iterator (available as `bufferIterator`).

NOTE: `fetchNextPartition` is used internally when <<doExecute, doExecute>>'s `Iterator` is requested for the <<next, next UnsafeRow>> (when `bufferIterator` is uninitialized or was drained, i.e. holds no elements, but there are still rows in the upstream operator's partition).

==== [[fetchNextRow]] `fetchNextRow` Internal Method

[source, scala]
----
fetchNextRow(): Unit
----

`fetchNextRow` checks whether there is the next row available (using the upstream `Iterator.hasNext`) and sets `nextRowAvailable` mutable internal flag.

If there is a row available, `fetchNextRow` sets `nextRow` internal variable to the next UnsafeRow.md[UnsafeRow] from the upstream's RDD.

`fetchNextRow` also sets `nextGroup` internal variable as an UnsafeRow.md[UnsafeRow] for `nextRow` using `grouping` function.

[[grouping]]
[NOTE]
====
`grouping` is a spark-sql-UnsafeProjection.md[UnsafeProjection] function that is spark-sql-UnsafeProjection.md#create[created] for <<partitionSpec, window partition specifications expressions>> to be bound to the single <<child, child>>'s output schema.

`grouping` uses spark-sql-GenerateUnsafeProjection.md[GenerateUnsafeProjection] to spark-sql-GenerateUnsafeProjection.md#canonicalize[canonicalize] the bound expressions and spark-sql-GenerateUnsafeProjection.md#create[create] the `UnsafeProjection` function.
====

If no row is available, `fetchNextRow` nullifies `nextRow` and `nextGroup` internal variables.

NOTE: `fetchNextRow` is used internally when <<doExecute, doExecute>>'s `Iterator` is created and <<fetchNextPartition, fetchNextPartition>> is called.

=== [[createResultProjection]] `createResultProjection` Internal Method

[source, scala]
----
createResultProjection(expressions: Seq[Expression]): UnsafeProjection
----

`createResultProjection` creates a [UnsafeProjection](UnsafeProjection.md) function for `expressions` window function [Catalyst expression](../expressions/Expression.md)s so that the window expressions are on the right side of child's output.

Internally, `createResultProjection` first creates a translation table with a [BoundReference](../expressions/BoundReference.md) per expression (in the input `expressions`).

`createResultProjection` then creates a window function bound references for <<windowExpression, window expressions>> so unbound expressions are transformed to the `BoundReferences`.

In the end, `createResultProjection` spark-sql-UnsafeProjection.md#create[creates a UnsafeProjection] with:

* `exprs` expressions from <<child, child>>'s output and the collection of window function bound references
* `inputSchema` input schema per <<child, child>>'s output

NOTE: `createResultProjection` is used exclusively when `WindowExec` is <<doExecute, executed>>.

=== [[creating-instance]] Creating WindowExec Instance

`WindowExec` takes the following when created:

* [[windowExpression]] Window spark-sql-Expression-NamedExpression.md[named expressions]
* [[partitionSpec]] Window partition specification expressions/Expression.md[expressions]
* [[orderSpec]] Window order specification (as a collection of `SortOrder` expressions)
* [[child]] Child <<SparkPlan.md#, physical operator>>

=== [[windowFrameExpressionFactoryPairs]] Lookup Table for WindowExpressions and Factory Functions for WindowFunctionFrame -- `windowFrameExpressionFactoryPairs` Lazy Value

[source, scala]
----
windowFrameExpressionFactoryPairs:
  Seq[(mutable.Buffer[WindowExpression], InternalRow => WindowFunctionFrame)]
----

`windowFrameExpressionFactoryPairs` is a lookup table with <<windowFrameExpressionFactoryPairs-two-element-expression-list-value, window expressions>> and <<windowFrameExpressionFactoryPairs-factory-functions, factory functions>> for spark-sql-WindowFunctionFrame.md[WindowFunctionFrame] (per key-value pair in `framedFunctions` lookup table).

A factory function is a function that takes an [InternalRow](../InternalRow.md) and produces a spark-sql-WindowFunctionFrame.md[WindowFunctionFrame] (described in the table below)

Internally, `windowFrameExpressionFactoryPairs` first builds `framedFunctions` lookup table with <<windowFrameExpressionFactoryPairs-four-element-tuple-key, 4-element tuple keys>> and <<windowFrameExpressionFactoryPairs-two-element-expression-list-value, 2-element expression list values>> (described in the table below).

`windowFrameExpressionFactoryPairs` finds spark-sql-Expression-WindowExpression.md[WindowExpression] expressions in the input <<windowExpression, windowExpression>> and for every `WindowExpression` takes the spark-sql-Expression-WindowSpecDefinition.md#frameSpecification[window frame specification] (of type `SpecifiedWindowFrame` that is used to find frame type and start and end frame positions).

[[windowFrameExpressionFactoryPairs-four-element-tuple-key]]
.framedFunctions's FrameKey -- 4-element Tuple for Frame Keys (in positional order)
[cols="1,2",options="header",width="100%"]
|===
| Element
| Description

| Name of the kind of function
a|

* *AGGREGATE* for spark-sql-Expression-AggregateFunction.md[AggregateFunction] (in [AggregateExpression](../expressions/AggregateExpression.md)s) or [AggregateWindowFunction](../expressions/AggregateWindowFunction.md)

* *OFFSET* for `OffsetWindowFunction`

| `FrameType`
| `RangeFrame` or `RowFrame`

| Window frame's start position
a|

* Positive number for `CurrentRow` (0) and `ValueFollowing`
* Negative number for `ValuePreceding`
* Empty when unspecified

| Window frame's end position
a|

* Positive number for `CurrentRow` (0) and `ValueFollowing`
* Negative number for `ValuePreceding`
* Empty when unspecified
|===

[[windowFrameExpressionFactoryPairs-two-element-expression-list-value]]
.framedFunctions's 2-element Tuple Values (in positional order)
[cols="1,2",options="header",width="100%"]
|===
| Element
| Description

| Collection of window expressions
| spark-sql-Expression-WindowExpression.md[WindowExpression]

| Collection of window functions
a|

* spark-sql-Expression-AggregateFunction.md[AggregateFunction] (in [AggregateExpression](../expressions/AggregateExpression.md)s) or `AggregateWindowFunction`

* `OffsetWindowFunction`
|===

`windowFrameExpressionFactoryPairs` creates a spark-sql-AggregateProcessor.md[AggregateProcessor] for `AGGREGATE` frame keys in `framedFunctions` lookup table.

[[windowFrameExpressionFactoryPairs-factory-functions]]
.windowFrameExpressionFactoryPairs' Factory Functions (in creation order)
[cols="1,2,2",options="header",width="100%"]
|===
| Frame Name
| FrameKey
| WindowFunctionFrame

| Offset Frame
| `("OFFSET", RowFrame, Some(offset), Some(h))`
| `OffsetWindowFunctionFrame`

| Growing Frame
| `("AGGREGATE", frameType, None, Some(high))`
| `UnboundedPrecedingWindowFunctionFrame`

| Shrinking Frame
| `("AGGREGATE", frameType, Some(low), None)`
| `UnboundedFollowingWindowFunctionFrame`

| Moving Frame
| `("AGGREGATE", frameType, Some(low), Some(high))`
| `SlidingWindowFunctionFrame`

| [[entire-partition-frame]] Entire Partition Frame
| `("AGGREGATE", frameType, None, None)`
| spark-sql-WindowFunctionFrame.md#UnboundedWindowFunctionFrame[UnboundedWindowFunctionFrame]
|===

NOTE: `lazy val` in Scala is computed when first accessed and once only (for the entire lifetime of the owning object instance).

NOTE: `windowFrameExpressionFactoryPairs` is used exclusively when `WindowExec` is <<doExecute, executed>>.

=== [[createBoundOrdering]] `createBoundOrdering` Internal Method

[source, scala]
----
createBoundOrdering(frame: FrameType, bound: Expression, timeZone: String): BoundOrdering
----

`createBoundOrdering`...FIXME

NOTE: `createBoundOrdering` is used exclusively when `WindowExec` physical operator is requested for the <<windowFrameExpressionFactoryPairs, window frame factories>>.
