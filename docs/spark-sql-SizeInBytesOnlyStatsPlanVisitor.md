title: SizeInBytesOnlyStatsPlanVisitor

# SizeInBytesOnlyStatsPlanVisitor -- LogicalPlanVisitor for Total Size (in Bytes) Statistic Only

`SizeInBytesOnlyStatsPlanVisitor` is a spark-sql-LogicalPlanVisitor.md[LogicalPlanVisitor] that computes a single dimension for [plan statistics](logical-operators/Statistics.md), i.e. the total size (in bytes).

=== [[default]] `default` Method

[source, scala]
----
default(p: LogicalPlan): Statistics
----

NOTE: `default` is part of spark-sql-LogicalPlanVisitor.md#default[LogicalPlanVisitor Contract] to compute the size statistic (in bytes) of a logical operator.

`default` requests a spark-sql-LogicalPlan-LeafNode.md[leaf logical operator] for the statistics or creates a [Statistics](logical-operators/Statistics.md) with the product of the `sizeInBytes` statistic of every [child operator](catalyst/TreeNode.md#children).

NOTE: `default` uses the cache of the estimated statistics of a logical operator so the statistics of an operator is [computed](logical-operators/LogicalPlanStats.md#stats) once until it is [invalidated](logical-operators/LogicalPlanStats.md#invalidateStatsCache).

=== [[visitIntersect]] `visitIntersect` Method

[source, scala]
----
visitIntersect(p: Intersect): Statistics
----

NOTE: `visitIntersect` is part of spark-sql-LogicalPlanVisitor.md#visitIntersect[LogicalPlanVisitor Contract] to...FIXME.

`visitIntersect`...FIXME

=== [[visitJoin]] `visitJoin` Method

[source, scala]
----
visitJoin(p: Join): Statistics
----

NOTE: `visitJoin` is part of spark-sql-LogicalPlanVisitor.md#visitJoin[LogicalPlanVisitor Contract] to...FIXME.

`visitJoin`...FIXME
