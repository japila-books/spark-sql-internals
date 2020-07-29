title: StaticInvoke

# StaticInvoke Non-SQL Expression

`StaticInvoke` is an expressions/Expression.md[expression] with expressions/Expression.md#NonSQLExpression[no SQL representation] that represents a static method call in Scala or Java.

`StaticInvoke` supports spark-sql-whole-stage-codegen.md[Java code generation] (aka _whole-stage codegen_) to evaluate itself.

`StaticInvoke` is <<creating-instance, created>> when:

* `ScalaReflection` is requested for the spark-sql-ExpressionEncoder.md#deserializerFor[deserializer] or spark-sql-ExpressionEncoder.md#serializerFor[serializer] for a Scala type

* spark-sql-RowEncoder.md[RowEncoder] is requested for `deserializerFor` or spark-sql-RowEncoder.md#serializerFor[serializer] for a Scala type

* `JavaTypeInference` is requested for `deserializerFor` or `serializerFor`

[source, scala]
----
import org.apache.spark.sql.types.StructType
val schema = new StructType()
  .add($"id".long.copy(nullable = false))
  .add($"name".string.copy(nullable = false))

import org.apache.spark.sql.catalyst.encoders.RowEncoder
val encoder = RowEncoder(schema)
scala> println(encoder.serializer(0).numberedTreeString)
00 validateexternaltype(getexternalrowfield(assertnotnull(input[0, org.apache.spark.sql.Row, true]), 0, id), LongType) AS id#1640L
01 +- validateexternaltype(getexternalrowfield(assertnotnull(input[0, org.apache.spark.sql.Row, true]), 0, id), LongType)
02    +- getexternalrowfield(assertnotnull(input[0, org.apache.spark.sql.Row, true]), 0, id)
03       +- assertnotnull(input[0, org.apache.spark.sql.Row, true])
04          +- input[0, org.apache.spark.sql.Row, true]
----

NOTE: `StaticInvoke` is similar to `CallMethodViaReflection` expression.

=== [[creating-instance]] Creating StaticInvoke Instance

`StaticInvoke` takes the following when created:

* [[staticObject]] Target object of the static call
* [[dataType]] spark-sql-DataType.md[Data type] of the return value of the <<functionName, method>>
* [[functionName]] Name of the method to call on the <<staticObject, static object>>
* [[arguments]] Optional expressions/Expression.md[expressions] to pass as input arguments to the <<functionName, function>>
* [[propagateNull]] Flag to control whether to propagate `nulls` or not (enabled by default). If any of the arguments is `null`, `null` is returned instead of calling the <<functionName, function>>
