---
title: Actions
---

# Dataset API &mdash; Actions

**Actions** are part of the [Dataset API](index.md).

!!! note
    Actions are the methods in the `Dataset` Scala class that are grouped in `action` group name, i.e. `@group action`.

<!---
## Review Me

[[methods]]
.Dataset API's Actions
[cols="1,2",options="header",width="100%"]
|===
| Action
| Description

| <<summary, summary>>
a| Computes specified statistics for numeric and string columns. The default statistics are: `count`, `mean`, `stddev`, `min`, `max` and `25%`, `50%`, `75%` percentiles.

[source, scala]
----
summary(statistics: String*): DataFrame
----

NOTE: `summary` is an extended version of the <<describe, describe>> action that simply calculates `count`, `mean`, `stddev`, `min` and `max` statistics.

|===

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
