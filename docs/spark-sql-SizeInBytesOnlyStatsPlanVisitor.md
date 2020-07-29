title: SizeInBytesOnlyStatsPlanVisitor

# SizeInBytesOnlyStatsPlanVisitor -- LogicalPlanVisitor for Total Size (in Bytes) Statistic Only

`SizeInBytesOnlyStatsPlanVisitor` is a spark-sql-LogicalPlanVisitor.md[LogicalPlanVisitor] that computes a single dimension for spark-sql-Statistics.md[plan statistics], i.e. the total size (in bytes).

=== [[default]] `default` Method

[source, scala]
----
default(p: LogicalPlan): Statistics
----

NOTE: `default` is part of spark-sql-LogicalPlanVisitor.md#default[LogicalPlanVisitor Contract] to compute the size statistic (in bytes) of a logical operator.

`default` requests a spark-sql-LogicalPlan-LeafNode.md[leaf logical operator] for the statistics or creates a spark-sql-Statistics.md[Statistics] with the product of the `sizeInBytes` statistic of every [child operator](catalyst/TreeNode.md#children).

NOTE: `default` uses the cache of the estimated statistics of a logical operator so the statistics of an operator is spark-sql-LogicalPlanStats.md#stats[computed] once until it is spark-sql-LogicalPlanStats.md#invalidateStatsCache[invalidated].

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
