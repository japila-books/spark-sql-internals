# InterpretedProjection

`InterpretedProjection` is a [Projection](Projection.md).

[[creating-instance]]
[[expressions]]
`InterpretedProjection` takes [Expression](Expression.md)s when created.

```text
// HACK: Disable symbolToColumn implicit conversion
// It is imported automatically in spark-shell (and makes demos impossible)
// implicit def symbolToColumn(s: Symbol): org.apache.spark.sql.ColumnName
trait ThatWasABadIdea
implicit def symbolToColumn(ack: ThatWasABadIdea) = ack

import org.apache.spark.sql.catalyst.dsl.expressions._
val boundRef = 'hello.string.at(4)

import org.apache.spark.sql.catalyst.expressions.{Expression, Literal}
val expressions: Seq[Expression] = Seq(Literal(1), boundRef)

import org.apache.spark.sql.catalyst.expressions.InterpretedProjection
val ip = new InterpretedProjection(expressions)
scala> println(ip)
Row => [1,input[4, string, true]]
```

`InterpretedProjection` is <<creating-instance, created>> when:

* `UserDefinedGenerator` is requested to `initializeConverters`

* `ConvertToLocalRelation` logical optimization is executed (to transform `Project` logical operators)

* `HiveGenericUDTF` is evaluated

* `ScriptTransformationExec` physical operator is executed

=== [[initialize]] Initializing Nondeterministic Expressions -- `initialize` Method

[source, scala]
----
initialize(partitionIndex: Int): Unit
----

NOTE: `initialize` is part of Projection.md#initialize[Projection Contract] to...FIXME.

`initialize` requests `Nondeterministic` expressions (in <<expressions, expressions>>) to spark-sql-Expression-Nondeterministic.md#initialize[initialize] with the `partitionIndex`.
