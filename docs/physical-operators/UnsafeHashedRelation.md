# UnsafeHashedRelation

`UnsafeHashedRelation` is...FIXME

=== [[get]] `get` Method

[source, scala]
----
get(key: InternalRow): Iterator[InternalRow]
----

`get`...FIXME

`get` is part of the [HashedRelation](HashedRelation.md#get) abstraction.

=== [[getValue]] Getting Value Row for Given Key -- `getValue` Method

[source, scala]
----
getValue(key: InternalRow): InternalRow
----

`getValue`...FIXME

`getValue` is part of the [HashedRelation](HashedRelation.md#getValue) abstraction.

=== [[apply]] Creating UnsafeHashedRelation Instance -- `apply` Factory Method

[source, scala]
----
apply(
  input: Iterator[InternalRow],
  key: Seq[Expression],
  sizeEstimate: Int,
  taskMemoryManager: TaskMemoryManager): HashedRelation
----

`apply`...FIXME

NOTE: `apply` is used when...FIXME
