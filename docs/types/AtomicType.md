# AtomicType

`AtomicType` is an [extension](#contract) of the [DataType](DataType.md) abstraction for [atomic types](#implementations).

## <span id="type"> InternalType

```scala
abstract class AtomicType extends DataType {
  type InternalType
}
```

## Contract

### <span id="tag"> TypeTag

```scala
tag: TypeTag[InternalType]
```

`TypeTag` ([Scala]({{ scala.docs }}/overviews/reflection/typetags-manifests.html))

### <span id="ordering"> Ordering

```scala
ordering: Ordering[InternalType]
```

## Implementations

* BinaryType
* BooleanType
* CharType
* DateType
* NumericType
* StringType
* TimestampType
* VarcharType

## <span id="unapply"> Extractor

```scala
unapply(
  e: Expression): Boolean
```

`unapply` is `true` when the [data type](../expressions/Expression.md#dataType) of the input [../expressions/Expression](../expressions/Expression.md) is an `AtomicType`.

`unapply` allows pattern matching in Scala against `AtomicType` for expressions.
