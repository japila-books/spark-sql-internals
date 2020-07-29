# HashedRelationBroadcastMode

`HashedRelationBroadcastMode` is a spark-sql-BroadcastMode.md[BroadcastMode] that `BroadcastHashJoinExec` uses for the spark-sql-SparkPlan-BroadcastHashJoinExec.md#requiredChildDistribution[required output distribution of child operators].

[[creating-instance]]
[[key]]
`HashedRelationBroadcastMode` takes build-side join keys (as expressions/Expression.md[Catalyst expressions]) when created.

[[canonicalized]]
`HashedRelationBroadcastMode` gives a copy of itself with <<key, keys>> canonicalized when requested for a spark-sql-BroadcastMode.md#canonicalized[canonicalized] version.

=== [[transform]] `transform` Method

[source, scala]
----
transform(rows: Array[InternalRow]): HashedRelation // <1>
transform(
  rows: Iterator[InternalRow],
  sizeHint: Option[Long]): HashedRelation
----
<1> Uses the other `transform` with the size of `rows` as `sizeHint`

NOTE: `transform` is part of spark-sql-BroadcastMode.md#transform[BroadcastMode Contract] to...FIXME.

`transform`...FIXME
