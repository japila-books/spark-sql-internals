title: Projection

# Projection -- Functions to Produce InternalRow for InternalRow

`Projection` is a <<contract, contract>> of Scala functions that produce an spark-sql-InternalRow.md[internal binary row] for a given internal row.

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

NOTE: `initialize` is overriden by spark-sql-InterpretedProjection.md#initialize[InterpretedProjection] and `InterpretedMutableProjection` projections that are used in expressions/Expression.md#eval[interpreted expression evaluation].

[[implementations]]
.Projections
[cols="1,2",options="header",width="100%"]
|===
| Projection
| Description

| [[UnsafeProjection]] spark-sql-UnsafeProjection.md[UnsafeProjection]
|

| [[InterpretedProjection]] spark-sql-InterpretedProjection.md[InterpretedProjection]
|

| [[IdentityProjection]] `IdentityProjection`
|

| [[MutableProjection]] `MutableProjection`
|

| [[InterpretedMutableProjection]] `InterpretedMutableProjection`
| _Appears not to be used anymore_
|===
