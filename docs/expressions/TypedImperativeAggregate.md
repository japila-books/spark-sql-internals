# TypedImperativeAggregate Expressions

`TypedImperativeAggregate` is an [extension](#contract) of the [ImperativeAggregate](ImperativeAggregate.md) abstraction for [typed ImperativeAggregates](#implementations).

??? note "Scala Definition"
    `TypedImperativeAggregate[T]` is a type constructor ([Scala]({{ scala.spec }}/03-types.html#type-constructors)) with `T` type parameter.

## Contract

### Creating Aggregation Buffer { #createAggregationBuffer }

```scala
createAggregationBuffer(): T
```

Creates an empty aggregation buffer object (to [initialize](#initialize) this `TypedImperativeAggregate`)

See:

* [BloomFilterAggregate](BloomFilterAggregate.md#createAggregationBuffer)
* [ScalaAggregator](ScalaAggregator.md#createAggregationBuffer)

Used when:

* `Collect` is requested to [deserialize](Collect.md#deserialize)
* `TypedImperativeAggregate` is requested to [initialize](#initialize)

### Deserializing { #deserialize }

```scala
deserialize(
  storageFormat: Array[Byte]): T
```

See:

* [BloomFilterAggregate](BloomFilterAggregate.md#deserialize)
* [ScalaAggregator](ScalaAggregator.md#deserialize)

Used when:

* `TypedImperativeAggregate` is requested to [merge](#merge-Expression)

### Interpreted Execution { #eval }

```scala
eval(
  buffer: T): Any
```

See:

* [BloomFilterAggregate](BloomFilterAggregate.md#eval)
* [ScalaAggregator](ScalaAggregator.md#eval)

Used when:

* `TypedImperativeAggregate` is requested to [execute (interpreted mode)](#eval-Expression)

### merge { #merge }

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

### Serializing Aggregate Buffer { #serialize }

```scala
serialize(
  buffer: T): Array[Byte]
```

See:

* [BloomFilterAggregate](BloomFilterAggregate.md#serialize)
* [ScalaAggregator](ScalaAggregator.md#serialize)

Used when:

* `TypedImperativeAggregate` is requested to [serialize the aggregate buffer in-place](#serializeAggregateBufferInPlace)

### update { #update }

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

## Interpreted Expression Evaluation { #eval-Expression }

??? note "Expression"

    ```scala
    eval(
      buffer: InternalRow): Any
    ```

    `eval` is part of the [Expression](Expression.md#eval) abstraction.

`eval` [take the buffer object](#getBufferObject) out of the given [InternalRow](../InternalRow.md) and [evaluates the result](#eval).

## Aggregate Buffer Attributes { #aggBufferAttributes }

??? note "AggregateFunction"

    ```scala
    aggBufferAttributes: Seq[AttributeReference]
    ```

    `aggBufferAttributes` is part of the [AggregateFunction](AggregateFunction.md#aggBufferAttributes) abstraction.

`aggBufferAttributes` is a single [AttributeReference](Attribute.md):

 Name  | DataType
-------|---------
 `buf` | [BinaryType](../types/DataType.md#BinaryType)

## Extracting Aggregate Buffer Object { #getBufferObject }

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

## ObjectType { #anyObjectType }

```scala
anyObjectType: ObjectType
```

When created, `TypedImperativeAggregate` creates an `ObjectType` of a value of Scala `AnyRef` type.

The `ObjectType` is used in [getBufferObject](#getBufferObject).

## Serializing Aggregate Buffer In-Place { #serializeAggregateBufferInPlace }

```scala
serializeAggregateBufferInPlace(
  buffer: InternalRow): Unit
```

??? warning "Procedure"
    `serializeAggregateBufferInPlace` is a procedure (returns `Unit`) so _whatever happens inside, stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`serializeAggregateBufferInPlace` [gets the aggregate buffer](#getBufferObject) from the given `buffer` and [serializes it](#serialize).

In the end, `serializeAggregateBufferInPlace` stores the serialized aggregate buffer back to the given `buffer` at [mutableAggBufferOffset](ImperativeAggregate.md#mutableAggBufferOffset).

---

`serializeAggregateBufferInPlace` is used when:

* `AggregatingAccumulator` is requested to [withBufferSerialized](../AggregatingAccumulator.md#withBufferSerialized)
* `AggregationIterator` is requested to [generateResultProjection](../aggregations/AggregationIterator.md#generateResultProjection)
* `ObjectAggregationMap` is requested to [dumpToExternalSorter](../aggregations/ObjectAggregationMap.md#dumpToExternalSorter)
