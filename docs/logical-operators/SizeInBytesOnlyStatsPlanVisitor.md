# SizeInBytesOnlyStatsPlanVisitor &mdash; LogicalPlanVisitor for Total Size (in Bytes) Statistic Only

`SizeInBytesOnlyStatsPlanVisitor` is a [LogicalPlanVisitor](LogicalPlanVisitor.md) that computes a single dimension for [plan statistics](Statistics.md), i.e. the total size (in bytes).

=== [[default]] `default` Method

[source, scala]
----
default(p: LogicalPlan): Statistics
----

`default` requests a spark-sql-LogicalPlan-LeafNode.md[leaf logical operator] for the statistics or creates a [Statistics](Statistics.md) with the product of the `sizeInBytes` statistic of every [child operator](../catalyst/TreeNode.md#children).

NOTE: `default` uses the cache of the estimated statistics of a logical operator so the statistics of an operator is [computed](LogicalPlanStats.md#stats) once until it is [invalidated](LogicalPlanStats.md#invalidateStatsCache).

`default` is part of the [LogicalPlanVisitor](LogicalPlanVisitor.md#default) abstraction.

=== [[visitIntersect]] `visitIntersect` Method

[source, scala]
----
visitIntersect(p: Intersect): Statistics
----

`visitIntersect`...FIXME

`visitIntersect` is part of the [LogicalPlanVisitor](LogicalPlanVisitor.md#visitIntersect) abstraction.

=== [[visitJoin]] `visitJoin` Method

[source, scala]
----
visitJoin(p: Join): Statistics
----

`visitJoin`...FIXME

`visitJoin` is part of the [LogicalPlanVisitor](LogicalPlanVisitor.md#visitJoin) abstraction.
