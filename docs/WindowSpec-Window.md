# Window Utility -- Defining Window Specification

`Window` utility object is a <<methods, set of static methods>> to define a <<WindowSpec.md#, window specification>>.

[[methods]]
.Window API
[cols="1m,3",options="header",width="100%"]
|===
| Method
| Description

| currentRow
a| [[currentRow]]

[source, scala]
----
currentRow: Long
----

Value representing the current row that is used to define <<WindowSpec.md#frame, frame boundaries>>.

| orderBy
a| [[orderBy]]

[source, scala]
----
orderBy(cols: Column*): WindowSpec
orderBy(colName: String, colNames: String*): WindowSpec
----

Creates a <<WindowSpec.md#, WindowSpec>> with the <<WindowSpec.md#orderSpec, ordering>> defined.

| partitionBy
a| [[partitionBy]]

[source, scala]
----
partitionBy(cols: Column*): WindowSpec
partitionBy(colName: String, colNames: String*): WindowSpec
----

Creates a <<WindowSpec.md#, WindowSpec>> with the <<WindowSpec.md#partitionSpec, partitioning>> defined.

| rangeBetween
a| [[rangeBetween]]

[source, scala]
----
rangeBetween(start: Column, end: Column): WindowSpec
rangeBetween(start: Long, end: Long): WindowSpec
----

Creates a <<WindowSpec.md#, WindowSpec>> with the <<WindowSpec.md#frame, frame boundaries>> defined, from `start` (inclusive) to `end` (inclusive). Both `start` and `end` are relative to the current row based on the actual value of the `ORDER BY` expression(s).

| rowsBetween
a| [[rowsBetween]]

[source, scala]
----
rowsBetween(start: Long, end: Long): WindowSpec
----

Creates a <<WindowSpec.md#, WindowSpec>> with the <<WindowSpec.md#frame, frame boundaries>> defined, from `start` (inclusive) to `end` (inclusive). Both `start` and `end` are positions relative to the current row based on the position of the row within the partition.

| unboundedFollowing
a| [[unboundedFollowing]]

[source, scala]
----
unboundedFollowing: Long
----

Value representing the last row in a partition (equivalent to "UNBOUNDED FOLLOWING" in SQL) that is used to define <<WindowSpec.md#frame, frame boundaries>>.

| unboundedPreceding
a| [[unboundedPreceding]]

[source, scala]
----
unboundedPreceding: Long
----

Value representing the first row in a partition (equivalent to "UNBOUNDED PRECEDING" in SQL) that is used to define <<WindowSpec.md#frame, frame boundaries>>.
|===

[source, scala]
----
import org.apache.spark.sql.expressions.Window
import org.apache.spark.sql.functions.{currentRow, lit}
val windowSpec = Window
  .partitionBy($"orderId")
  .orderBy($"time")
  .rangeBetween(currentRow, lit(1))
scala> :type windowSpec
org.apache.spark.sql.expressions.WindowSpec
----

=== [[spec]] Creating "Empty" WindowSpec -- `spec` Internal Method

```scala
spec: WindowSpec
```

`spec` creates an "empty" [WindowSpec](WindowSpec.md), i.e. with empty [partition](WindowSpec.md#partitionSpec) and [ordering](WindowSpec.md#orderSpec) specifications, and a `UnspecifiedFrame`.

`spec` is used when:

* [Column.over](Column.md#over) operator is used (with no `WindowSpec`)
* `Window` utility object is requested to [partitionBy](#partitionBy), [orderBy](#orderBy), [rowsBetween](#rowsBetween) and [rangeBetween](#rangeBetween)
