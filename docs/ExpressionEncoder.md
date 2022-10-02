# ExpressionEncoder

`ExpressionEncoder[T]` is the only built-in [Encoder](Encoder.md).

!!! important
    `ExpressionEncoder` is the only supported [Encoder](Encoder.md) which is enforced when `Dataset` [is created](Dataset.md#exprEnc) (even though `Dataset` data structure accepts a _bare_ `Encoder[T]`).

## Creating Instance

`ExpressionEncoder` takes the following to be created:

* <span id="objSerializer"> [Expression](expressions/Expression.md) for object serialization
* <span id="objDeserializer"> [Expression](expressions/Expression.md) for object deserialization
* <span id="clsTag"> `ClassTag[T]` ([Scala]({{ scala.api }}/scala/reflect/ClassTag.html))

`ExpressionEncoder` is created when:

* `Encoders` utility is used for [genericSerializer](Encoders.md#genericSerializer)
* `ExpressionEncoder` utility is used to [create one](#apply), [javaBean](#javaBean) and [tuple](#tuple)
* `RowEncoder` utility is used to [create one](RowEncoder.md#apply)

## <span id="serializer"> Serializer

```scala
serializer: Seq[NamedExpression]
```

`ExpressionEncoder` creates the `serializer` (to be [NamedExpression](expressions/NamedExpression.md)s) when [created](#creating-instance).

## Encoders Utility

[Encoders](Encoders.md) utility contains the `ExpressionEncoder` for Scala and Java primitive types, e.g. `boolean`, `long`, `String`, `java.sql.Date`, `java.sql.Timestamp`, `Array[Byte]`.

## Demo

```text
import org.apache.spark.sql.catalyst.encoders.ExpressionEncoder
val stringEncoder = ExpressionEncoder[String]
```

```text
scala> val row = stringEncoder.toRow("hello world")
row: org.apache.spark.sql.catalyst.InternalRow = [0,100000000b,6f77206f6c6c6568,646c72]
```

```scala
import org.apache.spark.sql.catalyst.expressions.UnsafeRow
```

```text
scala> val unsafeRow = row match { case ur: UnsafeRow => ur }
unsafeRow: org.apache.spark.sql.catalyst.expressions.UnsafeRow = [0,100000000b,6f77206f6c6c6568,646c72]
```

## <span id="apply"> Creating ExpressionEncoder

```scala
apply[T : TypeTag](): ExpressionEncoder[T]
```

`apply` creates an `ExpressionEncoder` with the following:

* [ScalaReflection.serializerForType](ScalaReflection.md#serializerForType)
* [ScalaReflection.deserializerForType](ScalaReflection.md#deserializerForType)

## <span id="tuple"> Creating ExpressionEncoder for Scala Tuples

```scala
tuple[T](
  e: ExpressionEncoder[T]): ExpressionEncoder[Tuple1[T]]
tuple[T1, T2](
  e1: ExpressionEncoder[T1],
  e2: ExpressionEncoder[T2]): ExpressionEncoder[(T1, T2)]
tuple[T1, T2, T3](
  e1: ExpressionEncoder[T1],
  e2: ExpressionEncoder[T2],
  e3: ExpressionEncoder[T3]): ExpressionEncoder[(T1, T2, T3)]
tuple[T1, T2, T3, T4](
  e1: ExpressionEncoder[T1],
  e2: ExpressionEncoder[T2],
  e3: ExpressionEncoder[T3],
  e4: ExpressionEncoder[T4]): ExpressionEncoder[(T1, T2, T3, T4)]
tuple[T1, T2, T3, T4, T5](
  e1: ExpressionEncoder[T1],
  e2: ExpressionEncoder[T2],
  e3: ExpressionEncoder[T3],
  e4: ExpressionEncoder[T4],
  e5: ExpressionEncoder[T5]): ExpressionEncoder[(T1, T2, T3, T4, T5)]
tuple(
  encoders: Seq[ExpressionEncoder[_]]): ExpressionEncoder[_]
```

`tuple`...FIXME

`tuple` is used when:

* `Dataset` is requested to [selectUntyped](Dataset.md#selectUntyped), [select](Dataset.md#select), [joinWith](Dataset.md#joinWith)
* `KeyValueGroupedDataset` is requested to [aggUntyped](basic-aggregation/KeyValueGroupedDataset.md#aggUntyped)
* `Encoders` utility is used to [tuple](Encoders.md#tuple)
* `ReduceAggregator` is requested for `bufferEncoder`

## <span id="javaBean"> Creating ExpressionEncoder for Java Bean

```scala
javaBean[T](
  beanClass: Class[T]): ExpressionEncoder[T]
```

`javaBean`...FIXME

`javaBean` is used when:

* `Encoders` utility is used to [bean](Encoders.md#bean)

## <span id="resolveAndBind"> resolveAndBind

```scala
resolveAndBind(
  attrs: Seq[Attribute] = schema.toAttributes,
  analyzer: Analyzer = SimpleAnalyzer): ExpressionEncoder[T]
```

`resolveAndBind` [creates a deserializer](CatalystSerde.md#deserialize) for a [LocalRelation](logical-operators/LocalRelation.md) with the given [Attribute](expressions/Attribute.md)s (to create a dummy query plan).

`resolveAndBind`...FIXME

`resolveAndBind` is used when:

* `ResolveEncodersInUDF` analysis rule is executed
* `Dataset` is requested for [resolvedEnc](Dataset.md#resolvedEnc)
* `TypedAggregateExpression` is created
* `ResolveEncodersInScalaAgg` extended resolution rule is executed
* _others_

### Demo

```text
case class Person(id: Long, name: String)
import org.apache.spark.sql.Encoders
val schema = Encoders.product[Person].schema

import org.apache.spark.sql.catalyst.encoders.{RowEncoder, ExpressionEncoder}
import org.apache.spark.sql.Row
val encoder: ExpressionEncoder[Row] = RowEncoder.apply(schema).resolveAndBind()

import org.apache.spark.sql.catalyst.InternalRow
val row = InternalRow(1, "Jacek")

val deserializer = encoder.deserializer

scala> deserializer.eval(row)
java.lang.UnsupportedOperationException: Only code-generated evaluation is supported
  at org.apache.spark.sql.catalyst.expressions.objects.CreateExternalRow.eval(objects.scala:1105)
  ... 54 elided

import org.apache.spark.sql.catalyst.expressions.codegen.CodegenContext
val ctx = new CodegenContext
val code = deserializer.genCode(ctx).code
```
