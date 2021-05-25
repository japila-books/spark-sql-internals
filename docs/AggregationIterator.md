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
