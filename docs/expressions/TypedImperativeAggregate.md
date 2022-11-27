# TypedImperativeAggregate Expressions

`TypedImperativeAggregate[T]` is an [extension](#contract) of the [ImperativeAggregate](ImperativeAggregate.md) abstraction for [typed ImperativeAggregates](#implementations).

## Contract (Subset)

### <span id="eval"> Interpreted Execution

```scala
eval(
  buffer: T): Any
```

Used when:

* `TypedImperativeAggregate` is requested to [execute (interpreted mode)](#eval-Expression)

## Implementations

* [ScalaAggregator](ScalaAggregator.md)
* `BloomFilterAggregate`
* _others_

## <span id="eval-Expression"> Interpreted Expression Evaluation

```scala
eval(
  buffer: InternalRow): Any
```

`eval` is part of the [Expression](Expression.md#eval) abstraction.

---

`eval` [evaluates](#eval) the result on [getBufferObject](#getBufferObject) for the given `buffer` [InternalRow](../InternalRow.md).

## <span id="getBufferObject"> getBufferObject

```scala
getBufferObject(
  bufferRow: InternalRow): T // (1)!
getBufferObject(
  buffer: InternalRow,
  offset: Int): T
```

1. Uses the [mutableAggBufferOffset](ImperativeAggregate.md#mutableAggBufferOffset) as the `offset`

`getBufferObject`...FIXME

---

`getBufferObject` is used when:

* `TypedImperativeAggregate` is requested to [mergeBuffersObjects](#mergeBuffersObjects), [update](#update), [merge](#merge), [eval](#eval-Expression), [serializeAggregateBufferInPlace](#serializeAggregateBufferInPlace)
