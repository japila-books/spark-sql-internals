# TypedImperativeAggregate Expressions

`TypedImperativeAggregate` is an [extension](#contract) of the [ImperativeAggregate](ImperativeAggregate.md) abstraction for [typed ImperativeAggregates](#implementations).

## Contract

### <span id="createAggregationBuffer"> Creating Aggregation Buffer

```scala
createAggregationBuffer(): T
```

See:

* [BloomFilterAggregate](BloomFilterAggregate.md#createAggregationBuffer)
* [ScalaAggregator](ScalaAggregator.md#createAggregationBuffer)

Used when:

* `Collect` is requested to [deserialize](Collect.md#deserialize)
* `TypedImperativeAggregate` is requested to [initialize](#initialize)

### <span id="deserialize"> Deserializing

```scala
deserialize(
  storageFormat: Array[Byte]): T
```

See:

* [BloomFilterAggregate](BloomFilterAggregate.md#deserialize)
* [ScalaAggregator](ScalaAggregator.md#deserialize)

Used when:

* `TypedImperativeAggregate` is requested to [merge](#merge-Expression)

### <span id="eval"> Interpreted Execution

```scala
eval(
  buffer: T): Any
```

See:

* [BloomFilterAggregate](BloomFilterAggregate.md#eval)
* [ScalaAggregator](ScalaAggregator.md#eval)

Used when:

* `TypedImperativeAggregate` is requested to [execute (interpreted mode)](#eval-Expression)

### <span id="merge"> merge

```scala
merge(
  buffer: T,
  input: T): T
```

See:

* [BloomFilterAggregate](BloomFilterAggregate.md#merge)
* [ScalaAggregator](ScalaAggregator.md#merge)

Used when:

* `TypedImperativeAggregate` is requested to [merge](#merge-Expression) and [mergeBuffersObjects](#mergeBuffersObjects)

### <span id="serialize"> serialize

```scala
serialize(
  buffer: T): Array[Byte]
```

See:

* [BloomFilterAggregate](BloomFilterAggregate.md#serialize)
* [ScalaAggregator](ScalaAggregator.md#serialize)

Used when:

* `TypedImperativeAggregate` is requested to [serializeAggregateBufferInPlace](#serializeAggregateBufferInPlace)

### <span id="update"> update

```scala
update(
  buffer: T,
  input: InternalRow): T
```

See:

* [BloomFilterAggregate](BloomFilterAggregate.md#update)
* [ScalaAggregator](ScalaAggregator.md#update)

Used when:

* `TypedImperativeAggregate` is requested to [update](#update)

## Implementations

* [BloomFilterAggregate](BloomFilterAggregate.md)
* [ScalaAggregator](ScalaAggregator.md)
* _others_

## <span id="eval-Expression"> Interpreted Expression Evaluation

```scala
eval(
  buffer: InternalRow): Any
```

`eval` is part of the [Expression](Expression.md#eval) abstraction.

---

`eval` [extracts the buffer object](#getBufferObject) (for the given [InternalRow](../InternalRow.md)) and [evaluates the result](#eval).

## <span id="aggBufferAttributes"> Aggregation Buffer Attributes

```scala
aggBufferAttributes: Seq[AttributeReference]
```

`aggBufferAttributes` is part of the [AggregateFunction](AggregateFunction.md#aggBufferAttributes) abstraction.

---

`aggBufferAttributes` is a single [AttributeReference](Attribute.md):

 Name  | DataType
-------|---------
 `buf` | [BinaryType](../types/DataType.md#BinaryType)

## <span id="getBufferObject"> Extracting Buffer Object

```scala
getBufferObject(
  bufferRow: InternalRow): T // (1)!
getBufferObject(
  buffer: InternalRow,
  offset: Int): T
```

1. Uses the [mutableAggBufferOffset](ImperativeAggregate.md#mutableAggBufferOffset) as the `offset`

`getBufferObject` requests the given [InternalRow](../InternalRow.md) for the value (of type `T`) at the given `offset` that is of [ObjectType](#anyObjectType) type.

---

`getBufferObject` is used when:

* `TypedImperativeAggregate` is requested to [mergeBuffersObjects](#mergeBuffersObjects), [update](#update), [merge](#merge), [eval](#eval-Expression), [serializeAggregateBufferInPlace](#serializeAggregateBufferInPlace)

## <span id="anyObjectType"> ObjectType

```scala
anyObjectType: ObjectType
```

When created, `TypedImperativeAggregate` creates an `ObjectType` of a value of Scala `AnyRef` type.

The `ObjectType` is used in [getBufferObject](#getBufferObject).
