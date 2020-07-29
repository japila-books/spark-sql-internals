# BroadcastMode

`BroadcastMode` is the <<contract, contract>> for...FIXME

[[contract]]
[source, scala]
----
package org.apache.spark.sql.catalyst.plans.physical

trait BroadcastMode {
  def canonicalized: BroadcastMode
  def transform(rows: Array[InternalRow]): Any
  def transform(rows: Iterator[InternalRow], sizeHint: Option[Long]): Any
}
----

.BroadcastMode Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| [[canonicalized]] `canonicalized`
| Used when...FIXME

| [[transform]] `transform`
a|

Used when:

* `BroadcastExchangeExec` is requested for spark-sql-SparkPlan-BroadcastExchangeExec.md#relationFuture[relationFuture] for the first time (when `BroadcastExchangeExec` is requested to spark-sql-SparkPlan-BroadcastExchangeExec.md#doPrepare[prepare for execution] as part of SparkPlan.md#executeQuery[executing a physical operator])

* `HashedRelationBroadcastMode` is requested to spark-sql-HashedRelationBroadcastMode.md#transform[transform] internal rows (and build a spark-sql-HashedRelation.md#apply[HashedRelation])

NOTE: The `rows`-only variant does not seem to be used at all.
|===

[[implementations]]
.BroadcastModes
[cols="1,2",options="header",width="100%"]
|===
| BroadcastMode
| Description

| [[HashedRelationBroadcastMode]] spark-sql-HashedRelationBroadcastMode.md[HashedRelationBroadcastMode]
|

| [[IdentityBroadcastMode]] spark-sql-IdentityBroadcastMode.md[IdentityBroadcastMode]
|
|===
