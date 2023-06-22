# AggregationIterator

`AggregationIterator` is an [abstraction](#contract) of [aggregation iterators](#implementations) (of [UnsafeRow](../UnsafeRow.md)s) that are used by [aggregate physical operators](../physical-operators/BaseAggregateExec.md) to process rows in a partition.

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
* <span id="groupingExpressions"> Grouping [NamedExpression](../expressions/NamedExpression.md)s
* <span id="inputAttributes"> Input [Attribute](../expressions/Attribute.md)s
* <span id="aggregateExpressions"> [AggregateExpression](../expressions/AggregateExpression.md)s
* <span id="aggregateAttributes"> Aggregate [Attribute](../expressions/Attribute.md)s
* <span id="initialInputBufferOffset"> Initial input buffer offset
* <span id="resultExpressions"> Result [NamedExpression](../expressions/NamedExpression.md)s
* <span id="newMutableProjection"> Function to create a new `MutableProjection` given expressions and attributes (`(Seq[Expression], Seq[Attribute]) => MutableProjection`)

??? note "Abstract Class"
    `AggregationIterator` is an abstract class and cannot be created directly. It is created indirectly for the [concrete AggregationIterators](#implementations).

## <span id="AggregateModes"> AggregateModes

When [created](#creating-instance), `AggregationIterator` makes sure that there are at most 2 distinct `AggregateMode`s of the [AggregateExpression](#aggregateExpressions)s.

The `AggregateMode`s have to be a subset of the following mode pairs:

* `Partial` and `PartialMerge`
* `Final` and `Complete`

## Process Row Function { #processRow }

```scala
processRow: (InternalRow, InternalRow) => Unit
```

`AggregationIterator` [generates](#generateProcessRow) a `processRow` function when [created](#creating-instance).

??? note "`processRow` is a procedure"
    `processRow` is a procedure that takes two [InternalRow](../InternalRow.md)s and produces no output (returns `Unit`).

    `processRow` is similar to the following definition:

    ```scala
    def processRow(currentBuffer: InternalRow, row: InternalRow): Unit = {
      ...
    }
    ```

`AggregationIterator` uses the [aggregateExpressions](#aggregateExpressions), the [aggregateFunctions](#aggregateFunctions) and the [inputAttributes](#inputAttributes) to [generate the processRow procedure](#generateProcessRow).

---

`processRow` is used when:

* `MergingSessionsIterator` is requested to `processCurrentSortedGroup`
* `ObjectAggregationIterator` is requested to [process input rows](ObjectAggregationIterator.md#processInputs)
* `SortBasedAggregationIterator` is requested to [processCurrentSortedGroup](SortBasedAggregationIterator.md#processCurrentSortedGroup)
* `TungstenAggregationIterator` is requested to [process input rows](TungstenAggregationIterator.md#processInputs)

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

`initializeAggregateFunctions` is used when:

* `AggregationIterator` is requested for the [aggregateFunctions](#aggregateFunctions)
* `ObjectAggregationIterator` is requested for the [mergeAggregationBuffers](ObjectAggregationIterator.md#mergeAggregationBuffers)
* `TungstenAggregationIterator` is requested to [switchToSortBasedAggregation](TungstenAggregationIterator.md#switchToSortBasedAggregation)

## Generate Output Function { #generateOutput }

```scala
generateOutput: (UnsafeRow, InternalRow) => UnsafeRow
```

`AggregationIterator` [creates a ResultProjection function](#generateResultProjection) when [created](#creating-instance).

`generateOutput` is used by the [aggregate iterators](#implementations) when they are requested for the next element (aggregate result) and generate an output for empty grouping with no input.

Aggregate Iterators | Operations
--------------------|-----------
 `ObjectAggregationIterator` | <ul><li>[next element](ObjectAggregationIterator.md#next)<li>[outputForEmptyGroupingKeyWithoutInput](ObjectAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput)</ul>
 `SortBasedAggregationIterator` | <ul><li>[next element](SortBasedAggregationIterator.md#next)<li>[outputForEmptyGroupingKeyWithoutInput](SortBasedAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput)</ul>
 `TungstenAggregationIterator` | <ul><li>[next element](TungstenAggregationIterator.md#next)<li>[outputForEmptyGroupingKeyWithoutInput](TungstenAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput)</ul>

### Generating Result Projection { #generateResultProjection }

```scala
generateResultProjection(): (UnsafeRow, InternalRow) => UnsafeRow
```

??? note "TungstenAggregationIterator"
    [TungstenAggregationIterator](TungstenAggregationIterator.md) overrides [generateResultProjection](TungstenAggregationIterator.md#generateResultProjection) for partial aggregation (non-`Final` and non-`Complete` aggregate modes).

`generateResultProjection` branches off based on the [aggregate modes](../expressions/AggregateExpression.md#mode) of the [aggregates](#aggregateExpressions):

1. [Final and Complete](#generateResultProjection-final-complete)
1. [Partial and PartialMerge](#generateResultProjection-partial-partialmerge)
1. [No modes](#generateResultProjection-no-modes)

!!! note "Main Differences between Aggregate Modes"

    Final and Complete | Partial and PartialMerge
    -------------------|-------------------------
    Focus on [DeclarativeAggregate](../expressions/DeclarativeAggregate.md)s to execute the [evaluateExpression](../expressions/DeclarativeAggregate.md#evaluateExpression)s (while the [allImperativeAggregateFunctions](#allImperativeAggregateFunctions) simply [eval](../expressions/Expression.md#eval)) | Focus on [TypedImperativeAggregate](../expressions/TypedImperativeAggregate.md)s so they can [serializeAggregateBufferInPlace](../expressions/TypedImperativeAggregate.md#serializeAggregateBufferInPlace)
    An [UnsafeProjection](../expressions/UnsafeProjection.md) binds the [resultExpressions](#resultExpressions) to the following:<ol><li> [groupingAttributes](#groupingAttributes)<li>the [aggregateAttributes](#aggregateAttributes)</ol> | An [UnsafeProjection](../expressions/UnsafeProjection.md) binds the [groupingAttributes](#groupingAttributes) and [bufferAttributes](#bufferAttributes) to the following (repeated twice rightly):<ol><li>the [groupingAttributes](#groupingAttributes)<li>the [bufferAttributes](#bufferAttributes)</ol>
    Uses an [UnsafeProjection](../expressions/UnsafeProjection.md) to generate an [UnsafeRow](../UnsafeRow.md) for the following:<ol><li>the current grouping key<li>the aggregate results</ol> | Uses an [UnsafeProjection](../expressions/UnsafeProjection.md) to generate an [UnsafeRow](../UnsafeRow.md) for the following:<ol><li>the current grouping key<li>the current buffer</ol>

#### Final and Complete { #generateResultProjection-final-complete }

For [Final](../expressions/AggregateExpression.md#Final) or [Complete](../expressions/AggregateExpression.md#Complete) modes, `generateResultProjection` does the following:

1. Collects [expressions to evaluate the final value](../expressions/DeclarativeAggregate.md#evaluateExpression)s of the [DeclarativeAggregate](../expressions/DeclarativeAggregate.md)s and `NoOp`s for the [AggregateFunction](../expressions/AggregateFunction.md)s among the [aggregateFunctions](#aggregateFunctions). `generateResultProjection` preserves the order of the evaluate expressions and `NoOp`s (so the `i`th aggregate function uses the `i`th evaluation expressions)
1. Executes the [newMutableProjection](#newMutableProjection) with the evaluation expressions and the [aggBufferAttributes](../expressions/AggregateFunction.md#aggBufferAttributes) of the [aggregateFunctions](#aggregateFunctions) to create a [MutableProjection](../expressions/MutableProjection.md)
1. Requests the `MutableProjection` to [store the aggregate results](../expressions/MutableProjection.md#target) (of all the [DeclarativeAggregate](../expressions/DeclarativeAggregate.md)s) in a `SpecificInternalRow`
1. [Creates an UnsafeProjection](../expressions/UnsafeProjection.md#create) for the [resultExpressions](#resultExpressions) and the [groupingAttributes](#groupingAttributes) with the [aggregateAttributes](#aggregateAttributes) (for the input schema)
1. Initializes the `UnsafeProjection` with the [partIndex](#partIndex)

In the end, `generateResultProjection` creates a result projection function that does the following:

1. Generates results for all expression-based aggregate functions (using the `MutableProjection` with the given `currentBuffer`)
1. Generates results for all [imperative aggregate functions](#allImperativeAggregateFunctions)
1. Uses the `UnsafeProjection` to generate an [UnsafeRow](../UnsafeRow.md) with the aggregate results for the current grouping key and the aggregate results

#### Partial and PartialMerge { #generateResultProjection-partial-partialmerge }

For [Partial](../expressions/AggregateExpression.md#Partial) or [PartialMerge](../expressions/AggregateExpression.md#PartialMerge) modes, `generateResultProjection` does the following:

1. [Creates an UnsafeProjection](../expressions/UnsafeProjection.md#create) for the [groupingAttributes](#groupingAttributes) with the [aggBufferAttributes](../expressions/AggregateFunction.md#aggBufferAttributes) of the [aggregateFunctions](#aggregateFunctions)
1. Initializes the `UnsafeProjection` with the [partIndex](#partIndex)
1. Collects the [TypedImperativeAggregate](../expressions/TypedImperativeAggregate.md)s from the [aggregateFunctions](#aggregateFunctions) (as they store a generic object in an aggregation buffer, and require calling serialization before shuffling)

In the end, `generateResultProjection` creates a result projection function that does the following:

1. Requests the [TypedImperativeAggregate](../expressions/TypedImperativeAggregate.md)s (from the [aggregateFunctions](#aggregateFunctions)) to [serializeAggregateBufferInPlace](../expressions/TypedImperativeAggregate.md#serializeAggregateBufferInPlace) with the given `currentBuffer`
1. Uses the `UnsafeProjection` to generate an [UnsafeRow](../UnsafeRow.md) with the current grouping key and buffer

#### No Modes { #generateResultProjection-no-modes }

For no aggregate modes, `generateResultProjection`...FIXME

## Initializing Aggregation Buffer { #initializeBuffer }

```scala
initializeBuffer(
  buffer: InternalRow): Unit
```

`initializeBuffer` requests the [expressionAggInitialProjection](#expressionAggInitialProjection) to [store an execution result](../expressions/MutableProjection.md#target) of an empty row in the given [InternalRow](../InternalRow.md) (`buffer`).

`initializeBuffer` requests [all the ImperativeAggregate functions](#allImperativeAggregateFunctions) to [initialize](../expressions/ImperativeAggregate.md#initialize) with the `buffer` internal row.

---

`initializeBuffer` is used when:

* `MergingSessionsIterator` is requested to `newBuffer`, `initialize`, `next`, `outputForEmptyGroupingKeyWithoutInput`
* `SortBasedAggregationIterator` is requested to [newBuffer](SortBasedAggregationIterator.md#newBuffer), [initialize](SortBasedAggregationIterator.md#initialize), [next](SortBasedAggregationIterator.md#next) and [outputForEmptyGroupingKeyWithoutInput](SortBasedAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput)

## Generating Process Row Function { #generateProcessRow }

```scala
generateProcessRow(
  expressions: Seq[AggregateExpression],
  functions: Seq[AggregateFunction],
  inputAttributes: Seq[Attribute]): (InternalRow, InternalRow) => Unit
```

`generateProcessRow` creates a mutable `JoinedRow` (of two [InternalRow](../InternalRow.md)s).

`generateProcessRow` branches off based on the given [AggregateExpression](../expressions/AggregateExpression.md)s, [specified](#generateProcessRow-aggregate-expressions-specified) or [not](#generateProcessRow-no-aggregate-expressions).

??? note "Where AggregateExpressions come from"

    Caller | AggregateExpressions
    -------|---------------------
    [AggregationIterator](#processRow) | [aggregateExpressions](#aggregateExpressions)
    [ObjectAggregationIterator](ObjectAggregationIterator.md#mergeAggregationBuffers) | [aggregateExpressions](ObjectAggregationIterator.md#aggregateExpressions)
    [TungstenAggregationIterator](TungstenAggregationIterator.md#switchToSortBasedAggregation) | [aggregateExpressions](TungstenAggregationIterator.md#aggregateExpressions)

!!! note "`functions` Argument"
    `generateProcessRow` works differently based on the type of the given [AggregateFunction](../expressions/AggregateFunction.md)s:

    * [DeclarativeAggregate](../expressions/DeclarativeAggregate.md)
    * [AggregateFunction](../expressions/AggregateFunction.md)
    * [ImperativeAggregate](../expressions/ImperativeAggregate.md)

---

`generateProcessRow` is used when:

* `AggregationIterator` is requested for the [process row function](#processRow)
* `ObjectAggregationIterator` is requested for the [mergeAggregationBuffers function](ObjectAggregationIterator.md#mergeAggregationBuffers)
* `TungstenAggregationIterator` is requested to [switch to sort-based aggregation](TungstenAggregationIterator.md#switchToSortBasedAggregation)

### Aggregate Expressions Specified { #generateProcessRow-aggregate-expressions-specified }

#### Merge Expressions { #generateProcessRow-aggregate-expressions-specified-merge-expressions }

With [AggregateExpression](../expressions/AggregateExpression.md)s specified, `generateProcessRow` determines so-called "merge expressions" (`mergeExpressions`) as follows:

* For [DeclarativeAggregate](../expressions/DeclarativeAggregate.md) functions, the merge expressions are choosen based on the [AggregateMode](../expressions/AggregateExpression.md#mode) of the corresponding [AggregateExpression](../expressions/AggregateExpression.md)

     AggregateMode | Merge Expressions
    ---------------|------------------
    `Partial` or `Complete` | [Update Expressions](../expressions/DeclarativeAggregate.md#updateExpressions) of a `DeclarativeAggregate`
    `PartialMerge` or `Final` | [Merge Expressions](../expressions/DeclarativeAggregate.md#mergeExpressions) of a `DeclarativeAggregate`

* For [AggregateFunction](../expressions/AggregateFunction.md) functions, there are as many `NoOp` merge expressions (that do nothing and do not change a value) as there are [aggBufferAttributes](../expressions/AggregateFunction.md#aggBufferAttributes) in a `AggregateFunction`

#### Initialize Predicates { #generateProcessRow-aggregate-expressions-specified-initialize-predicates }

`generateProcessRow` finds [AggregateExpression](../expressions/AggregateExpression.md)s with [filter](../expressions/AggregateExpression.md#filter)s specified.

When in `Partial` or `Complete` aggregate modes, `generateProcessRow`...FIXME

#### Update Functions { #generateProcessRow-aggregate-expressions-specified-update-functions }

`generateProcessRow` determines so-called "update functions" (`updateFunctions`) among [ImperativeAggregate](../expressions/ImperativeAggregate.md) functions (in the given [AggregateFunction](../expressions/AggregateFunction.md)s) to be as follows:

* FIXME

#### Update Projection { #generateProcessRow-aggregate-expressions-specified-update-projection }

`generateProcessRow` uses the [newMutableProjection](#newMutableProjection) generator function to create a [MutableProjection](../expressions/MutableProjection.md) based on the `mergeExpressions` and the [aggBufferAttributes](../expressions/AggregateFunction.md#aggBufferAttributes) of the given [AggregateFunction](../expressions/AggregateFunction.md)s with the given `inputAttributes`.

#### Process Row Function { #generateProcessRow-aggregate-expressions-specified-process-row-function }

In the end, `generateProcessRow` creates a procedure that accepts two [InternalRow](../InternalRow.md)s (`currentBuffer` and `row`) that does the following:

1. Processes all [expression-based aggregate](../expressions/DeclarativeAggregate.md) functions (using `updateProjection`).`generateProcessRow` requests the [MutableProjection](../expressions/MutableProjection.md) to [store the output](../expressions/MutableProjection.md#target) in the `currentBuffer`. The output is created based on the `currentBuffer` and the `row`.
1. Processes all [imperative aggregate](../expressions/ImperativeAggregate.md) functions. `generateProcessRow` requests every "update function"  (in `updateFunctions`) to execute with the given `currentBuffer` and the `row`.

### No Aggregate Expressions { #generateProcessRow-no-aggregate-expressions }

With no [AggregateExpression](../expressions/AggregateExpression.md)s (`expressions`), `generateProcessRow` creates a function that does nothing ("swallows" the input).
