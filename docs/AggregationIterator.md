# AggregationIterators

`AggregationIterator` is an [abstraction](#contract) of [iterators](#implementations) of [UnsafeRow](UnsafeRow.md)s.

```scala
abstract class AggregationIterator(...)
extends Iterator[UnsafeRow]
```

From [scala.collection.Iterator]({{ scala.api }}/scala/collection/Iterator.html):

> Iterators are data structures that allow to iterate over a sequence of elements. They have a `hasNext` method for checking if there is a next element available, and a `next` method which returns the next element and discards it from the iterator.

## Implementations

* [ObjectAggregationIterator](ObjectAggregationIterator.md)
* [SortBasedAggregationIterator](SortBasedAggregationIterator.md)
* [TungstenAggregationIterator](TungstenAggregationIterator.md)

## Creating Instance

`AggregationIterator` takes the following to be created:

* <span id="partIndex"> Partition ID
* <span id="groupingExpressions"> Grouping [NamedExpression](expressions/NamedExpression.md)s
* <span id="inputAttributes"> Input [Attribute](expressions/Attribute.md)s
* <span id="aggregateExpressions"> [AggregateExpression](expressions/AggregateExpression.md)s
* <span id="aggregateAttributes"> Aggregate [Attribute](expressions/Attribute.md)s
* <span id="initialInputBufferOffset"> Initial input buffer offset
* <span id="resultExpressions"> Result [NamedExpression](expressions/NamedExpression.md)s
* <span id="newMutableProjection"> Function to create a new `MutableProjection` given expressions and attributes (`(Seq[Expression], Seq[Attribute]) => MutableProjection`)

??? note "Abstract Class"
    `AggregationIterator` is an abstract class and cannot be created directly. It is created indirectly for the [concrete AggregationIterators](#implementations).

## <span id="AggregateModes"> AggregateModes

When [created](#creating-instance), `AggregationIterator` makes sure that there are at most 2 distinct `AggregateMode`s of the [AggregateExpression](#aggregateExpressions)s.

The `AggregateMode`s have to be a subset of the following mode pairs:

* `Partial` and `PartialMerge`
* `Final` and `Complete`

## <span id="aggregateFunctions"> AggregateFunctions

```scala
aggregateFunctions: Array[AggregateFunction]
```

When [created](#creating-instance), `AggregationIterator` [initializes AggregateFunctions](#initializeAggregateFunctions) in the [aggregateExpressions](#aggregateExpressions) (with [initialInputBufferOffset](#initialInputBufferOffset)).

## <span id="initializeAggregateFunctions"> initializeAggregateFunctions

```scala
initializeAggregateFunctions(
  expressions: Seq[AggregateExpression],
  startingInputBufferOffset: Int): Array[AggregateFunction]
```

`initializeAggregateFunctions`...FIXME

`initializeAggregateFunctions` is used when:

* `AggregationIterator` is requested for the [aggregateFunctions](#aggregateFunctions)
* `ObjectAggregationIterator` is requested for the [mergeAggregationBuffers](ObjectAggregationIterator.md#mergeAggregationBuffers)
* `TungstenAggregationIterator` is requested to [switchToSortBasedAggregation](TungstenAggregationIterator.md#switchToSortBasedAggregation)

## <span id="generateProcessRow"> generateProcessRow

```scala
generateProcessRow(
  expressions: Seq[AggregateExpression],
  functions: Seq[AggregateFunction],
  inputAttributes: Seq[Attribute]): (InternalRow, InternalRow) => Unit
```

`generateProcessRow`...FIXME

`generateProcessRow` is used when:

* `AggregationIterator` is requested for the [processRow function](#processRow)
* `ObjectAggregationIterator` is requested for the [mergeAggregationBuffers function](ObjectAggregationIterator.md#mergeAggregationBuffers)
* `TungstenAggregationIterator` is requested to [switchToSortBasedAggregation](TungstenAggregationIterator.md#switchToSortBasedAggregation)

## <span id="generateOutput"> generateOutput

```scala
generateOutput: (UnsafeRow, InternalRow) => UnsafeRow
```

When [created](#creating-instance), `AggregationIterator` [creates a ResultProjection function](#generateResultProjection).

`generateOutput` is used when:

* `ObjectAggregationIterator` is requested for the [next element](ObjectAggregationIterator.md#next) and to [outputForEmptyGroupingKeyWithoutInput](ObjectAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput)
* `SortBasedAggregationIterator` is requested for the [next element](SortBasedAggregationIterator.md#next) and to [outputForEmptyGroupingKeyWithoutInput](SortBasedAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput)
* `TungstenAggregationIterator` is requested for the [next element](TungstenAggregationIterator.md#next) and to [outputForEmptyGroupingKeyWithoutInput](TungstenAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput)

### <span id="generateResultProjection"> generateResultProjection

```scala
generateResultProjection(): (UnsafeRow, InternalRow) => UnsafeRow
```

`generateResultProjection`...FIXME

## <span id="initializeBuffer"> initializeBuffer

```scala
initializeBuffer(
  buffer: InternalRow): Unit
```

`initializeBuffer`...FIXME

`initializeBuffer` is used when:

* `SortBasedAggregationIterator` is requested to [newBuffer](SortBasedAggregationIterator.md#newBuffer), [initialize](SortBasedAggregationIterator.md#initialize), [next](SortBasedAggregationIterator.md#next) and [outputForEmptyGroupingKeyWithoutInput](SortBasedAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput)
