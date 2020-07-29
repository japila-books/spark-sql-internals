# KnownSizeEstimation

`KnownSizeEstimation` is the <<contract, contract>> that allows a class to give spark-sql-SizeEstimator.md[SizeEstimator] a more accurate <<estimatedSize, size estimation>>.

[[contract]]
`KnownSizeEstimation` defines the single `estimatedSize` method.

[source, scala]
----
package org.apache.spark.util

trait KnownSizeEstimation {
  def estimatedSize: Long
}
----

`estimatedSize` is used when:

* `SizeEstimator` is requested to spark-sql-SizeEstimator.md#visitSingleObject[visitSingleObject]

* `BroadcastExchangeExec` is requested for spark-sql-SparkPlan-BroadcastExchangeExec.md#relationFuture[relationFuture]

* `BroadcastHashJoinExec` is requested to spark-sql-SparkPlan-BroadcastHashJoinExec.md#doExecute[execute]

* `ShuffledHashJoinExec` is requested to spark-sql-SparkPlan-ShuffledHashJoinExec.md#buildHashedRelation[buildHashedRelation]

NOTE: `KnownSizeEstimation` is a `private[spark]` contract.

NOTE: spark-sql-HashedRelation.md[HashedRelation] is the only `KnownSizeEstimation` available.
