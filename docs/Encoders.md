# Encoders Utility

## Demo

```scala
import org.apache.spark.sql.Encoders
val encoder = Encoders.LOCALDATE
```

```text
scala> :type encoder
org.apache.spark.sql.Encoder[java.time.LocalDate]
```

## <span id="javaSerialization"> Creating Generic ExpressionEncoder using Java Serialization

```scala
javaSerialization[T: ClassTag]: Encoder[T]
javaSerialization[T](
  clazz: Class[T]): Encoder[T]
```

`javaSerialization` [creates a generic ExpressionEncoder](#genericSerializer) (with `useKryo` flag off).

## <span id="kryo"> Creating Generic ExpressionEncoder using Kryo Serialization

```scala
kryo[T: ClassTag]: Encoder[T]
kryo[T](
  clazz: Class[T]): Encoder[T]
```

`kryo` [creates a generic ExpressionEncoder](#genericSerializer) (with `useKryo` flag on).

## <span id="genericSerializer"> Creating Generic ExpressionEncoder

```scala
genericSerializer[T: ClassTag](
  useKryo: Boolean): Encoder[T]
```

`genericSerializer` creates an [ExpressionEncoder](ExpressionEncoder.md) with the following:

Attribute | Catalyst Expression
---------|---------
 `objSerializer` | [EncodeUsingSerializer](expressions/EncodeUsingSerializer.md) with [BoundReference](expressions/BoundReference.md) (`ordinal` = 0, `dataType` = [ObjectType](types/DataType.md#ObjectType))
 `objDeserializer` | [DecodeUsingSerializer](expressions/DecodeUsingSerializer.md) with `GetColumnByOrdinal` leaf expression

`genericSerializer` is used when:

* `Encoders` utility is used for a generic encoder using [Kryo](#kryo) and [Java](#javaSerialization) serialization
