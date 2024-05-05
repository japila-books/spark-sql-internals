---
title: Actions
---

# Dataset API &nbsp; Actions

**Actions** are part of the <<dataset-operators.md#, Dataset API>> for...FIXME

<!---
## Review Me
NOTE: Actions are the methods in the `Dataset` Scala class that are grouped in `action` group name, i.e. `@group action`.

[[methods]]
.Dataset API's Actions
[cols="1,2",options="header",width="100%"]
|===
| Action
| Description

| <<collect, collect>>
a|

[source, scala]
----
collect(): Array[T]
----

| <<count, count>>
a|

[source, scala]
----
count(): Long
----

| <<describe, describe>>
a|

[source, scala]
----
describe(cols: String*): DataFrame
----

| <<first, first>>
a|

[source, scala]
----
first(): T
----

| <<foreach, foreach>>
a|

[source, scala]
----
foreach(f: T => Unit): Unit
----

| <<foreachPartition, foreachPartition>>
a|

[source, scala]
----
foreachPartition(f: Iterator[T] => Unit): Unit
----

| <<head, head>>
a|

[source, scala]
----
head(): T
head(n: Int): Array[T]
----

| <<reduce, reduce>>
a|

[source, scala]
----
reduce(func: (T, T) => T): T
----

| <<show, show>>
a|

[source, scala]
----
show(): Unit
show(truncate: Boolean): Unit
show(numRows: Int): Unit
show(numRows: Int, truncate: Boolean): Unit
show(numRows: Int, truncate: Int): Unit
show(numRows: Int, truncate: Int, vertical: Boolean): Unit
----

| <<summary, summary>>
a| Computes specified statistics for numeric and string columns. The default statistics are: `count`, `mean`, `stddev`, `min`, `max` and `25%`, `50%`, `75%` percentiles.

[source, scala]
----
summary(statistics: String*): DataFrame
----

NOTE: `summary` is an extended version of the <<describe, describe>> action that simply calculates `count`, `mean`, `stddev`, `min` and `max` statistics.

| <<take, take>>
a|

[source, scala]
----
take(n: Int): Array[T]
----

| <<toLocalIterator, toLocalIterator>>
a|

[source, scala]
----
toLocalIterator(): java.util.Iterator[T]
----
|===

=== [[head]] `head` Action

[source, scala]
----
head(): T // <1>
head(n: Int): Array[T]
----
<1> Calls the other `head` with `n` as `1` and takes the first element

`head`...FIXME

=== [[summary]] Calculating Statistics -- `summary` Action

[source, scala]
----
summary(statistics: String*): DataFrame
----

`summary` calculates specified statistics for numeric and string columns.

The default statistics are: `count`, `mean`, `stddev`, `min`, `max` and `25%`, `50%`, `75%` percentiles.

NOTE: `summary` accepts arbitrary approximate percentiles specified as a percentage (e.g. `10%`).

Internally, `summary` uses the `StatFunctions` to calculate the requested summaries for the `Dataset`.

=== [[take]] Taking First Records -- `take` Action

[source, scala]
----
take(n: Int): Array[T]
----

`take` is an action on a `Dataset` that returns a collection of `n` records.

WARNING: `take` loads all the data into the memory of the Spark application's driver process and for a large `n` could result in `OutOfMemoryError`.

Internally, `take` creates a new `Dataset` with `Limit` logical plan for `Literal` expression and the current `LogicalPlan`. It then runs the SparkPlan.md[SparkPlan] that produces a `Array[InternalRow]` that is in turn decoded to `Array[T]` using a bounded [encoder](Encoder.md).
-->
