# HashedRelationBroadcastMode

`HashedRelationBroadcastMode` is a [BroadcastMode](BroadcastMode.md) that `BroadcastHashJoinExec` uses for the BroadcastHashJoinExec.md#requiredChildDistribution[required output distribution of child operators].

[[creating-instance]]
[[key]]
`HashedRelationBroadcastMode` takes build-side join keys (as expressions/Expression.md[Catalyst expressions]) when created.

[[canonicalized]]
`HashedRelationBroadcastMode` gives a copy of itself with <<key, keys>> canonicalized when requested for a [canonicalized](BroadcastMode.md#canonicalized) version.
