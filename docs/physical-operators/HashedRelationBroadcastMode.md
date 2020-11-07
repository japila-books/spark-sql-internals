# HashedRelationBroadcastMode

`HashedRelationBroadcastMode` is a [BroadcastMode](BroadcastMode.md) that `BroadcastHashJoinExec` uses for the BroadcastHashJoinExec.md#requiredChildDistribution[required output distribution of child operators].

[[creating-instance]]
[[key]]
`HashedRelationBroadcastMode` takes build-side join keys (as expressions/Expression.md[Catalyst expressions]) when created.

[[canonicalized]]
`HashedRelationBroadcastMode` gives a copy of itself with <<key, keys>> canonicalized when requested for a [canonicalized](BroadcastMode.md#canonicalized) version.

=== [[transform]] `transform` Method

[source, scala]
----
transform(rows: Array[InternalRow]): HashedRelation // <1>
transform(
  rows: Iterator[InternalRow],
  sizeHint: Option[Long]): HashedRelation
----
<1> Uses the other `transform` with the size of `rows` as `sizeHint`

`transform`...FIXME

`transform` is part of the[BroadcastMode](BroadcastMode.md#transform) abstraction.
