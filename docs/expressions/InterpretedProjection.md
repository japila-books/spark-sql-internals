# InterpretedProjection

`InterpretedProjection` is a [Projection](Projection.md).

## Creating Instance

`InterpretedProjection` takes the following to be created:

* <span id="expressions"> [Expression](Expression.md)s
* <span id="inputSchema"> Input Schema ([Attribute](Attribute.md)s)

`InterpretedProjection` is created when:

* `HiveGenericUDTF` is requested to `eval`
* `HiveScriptTransformationExec` is requested to `processIterator`
* `SparkScriptTransformationExec` is requested to `processIterator`
* `UserDefinedGenerator` is requested to `initializeConverters`

## Demo

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
