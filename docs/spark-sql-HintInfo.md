# HintInfo

[[creating-instance]]
`HintInfo` takes a single <<broadcast, broadcast>> flag when created.

`HintInfo` is <<creating-instance, created>> when:

* [Dataset.broadcast](spark-sql-functions.md#broadcast) function is used

* [ResolveJoinStrategyHints](logical-analysis-rules/ResolveJoinStrategyHints.md) logical resolution rule is executed

* spark-sql-LogicalPlan-ResolvedHint.md#creating-instance[ResolvedHint] and [Statistics](logical-operators/Statistics.md) are created

* `InMemoryRelation` is requested for spark-sql-LogicalPlan-InMemoryRelation.md#computeStats[computeStats] (when spark-sql-LogicalPlan-InMemoryRelation.md#sizeInBytesStats[sizeInBytesStats] is `0`)

* `HintInfo` is requested to <<resetForJoin, resetForJoin>>

[[broadcast]]
`broadcast` is used to...FIXME

`broadcast` is off (i.e. `false`) by default.

[source, scala]
----
import org.apache.spark.sql.catalyst.plans.logical.HintInfo
val broadcastOff = HintInfo()

scala> println(broadcastOff.broadcast)
false

val broadcastOn = broadcastOff.copy(broadcast = true)
scala> println(broadcastOn)
(broadcast)

val broadcastOff = broadcastOn.resetForJoin
scala> println(broadcastOff.broadcast)
false
----

=== [[resetForJoin]] `resetForJoin` Method

[source, scala]
----
resetForJoin(): HintInfo
----

`resetForJoin`...FIXME

NOTE: `resetForJoin` is used when `SizeInBytesOnlyStatsPlanVisitor` is requested to spark-sql-SizeInBytesOnlyStatsPlanVisitor.md#visitIntersect[visitIntersect] and spark-sql-SizeInBytesOnlyStatsPlanVisitor.md#visitJoin[visitJoin].
