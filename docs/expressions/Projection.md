# Projection

`Projection` is a <<contract, contract>> of Scala functions that produce an [InternalRow](../InternalRow.md) for a given internal row.

[source, scala]
----
Projection: InternalRow => InternalRow
----

[[initialize]]
`Projection` can optionally be *initialized* with the current partition index (which by default does nothing).

[source, scala]
----
initialize(partitionIndex: Int): Unit = {}
----

NOTE: `initialize` is overriden by [InterpretedProjection](InterpretedProjection.md#initialize) and `InterpretedMutableProjection` projections that are used in [interpreted expression evaluation](Expression.md#eval).

[[implementations]]
.Projections
[cols="1,2",options="header",width="100%"]
|===
| Projection
| Description

| [[UnsafeProjection]] [UnsafeProjection](UnsafeProjection.md)
|

| [[InterpretedProjection]] [InterpretedProjection](InterpretedProjection.md)
|

| [[IdentityProjection]] `IdentityProjection`
|

| [[MutableProjection]] `MutableProjection`
|

| [[InterpretedMutableProjection]] `InterpretedMutableProjection`
| _Appears not to be used anymore_
|===
