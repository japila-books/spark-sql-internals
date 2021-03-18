title: AggregationIterator

# AggregationIterator -- Generic Iterator of UnsafeRows for Aggregate Physical Operators

`AggregationIterator` is the base for <<implementations, iterators>> of <<UnsafeRow.md, UnsafeRows>> that...FIXME

> Iterators are data structures that allow to iterate over a sequence of elements. They have a `hasNext` method for checking if there is a next element available, and a `next` method which returns the next element and discards it from the iterator.

[[implementations]]
.AggregationIterator's Implementations
[width="100%",cols="1,2",options="header"]
|===
| Name
| Description

| [ObjectAggregationIterator](ObjectAggregationIterator.md)
| Used when [ObjectHashAggregateExec](physical-operators/ObjectHashAggregateExec.md) physical operator is executed

| [SortBasedAggregationIterator](SortBasedAggregationIterator.md)
| Used when [SortAggregateExec](physical-operators/SortAggregateExec.md) physical operator is executed

| [TungstenAggregationIterator](TungstenAggregationIterator.md)
a| Used when [HashAggregateExec](physical-operators/HashAggregateExec.md) physical operator is executed

|===

[[internal-registries]]
.AggregationIterator's Internal Registries and Counters
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| [[aggregateFunctions]] `aggregateFunctions`
| [Aggregate functions](expressions/AggregateFunction.md)

Used when...FIXME

| [[allImperativeAggregateFunctions]] `allImperativeAggregateFunctions`
| [ImperativeAggregate](expressions/ImperativeAggregate.md) functions

Used when...FIXME

| [[allImperativeAggregateFunctionPositions]] `allImperativeAggregateFunctionPositions`
| Positions

Used when...FIXME

| [[expressionAggInitialProjection]] `expressionAggInitialProjection`
| `MutableProjection`

Used when...FIXME

| `generateOutput`
a| [[generateOutput]] Function used to generate an [unsafe row](UnsafeRow.md) (i.e. `(UnsafeRow, InternalRow) => UnsafeRow`)

Used when:

* `ObjectAggregationIterator` is requested for the [next unsafe row](ObjectAggregationIterator.md#next) and [outputForEmptyGroupingKeyWithoutInput](ObjectAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput)

* `SortBasedAggregationIterator` is requested for the [next unsafe row](SortBasedAggregationIterator.md#next) and [outputForEmptyGroupingKeyWithoutInput](SortBasedAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput)

* `TungstenAggregationIterator` is requested for the [next unsafe row](TungstenAggregationIterator.md#next) and [outputForEmptyGroupingKeyWithoutInput](TungstenAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput)

| [[groupingAttributes]] `groupingAttributes`
| Grouping [attribute](expressions/Attribute.md)s

Used when...FIXME

| [[groupingProjection]] `groupingProjection`
| [UnsafeProjection](expressions/UnsafeProjection.md)

Used when...FIXME

| [[processRow]] `processRow`
| `(InternalRow, InternalRow) => Unit`

Used when...FIXME
|===

## Creating Instance

`AggregationIterator` takes the following when created:

* [[groupingExpressions]] Grouping [named expressions](expressions/NamedExpression.md)
* [[inputAttributes]] Input [attribute](expressions/Attribute.md)s
* [[aggregateExpressions]] [Aggregate expressions](expressions/AggregateExpression.md)
* [[aggregateAttributes]] Aggregate [attribute](expressions/Attribute.md)s
* [[initialInputBufferOffset]] Initial input buffer offset
* [[resultExpressions]] Result [named expressions](expressions/NamedExpression.md)
* [[newMutableProjection]] Function to create a new `MutableProjection` given expressions and attributes

!!! note
    `AggregationIterator` is a Scala abstract class and cannot be created directly. It is created indirectly for the [concrete AggregationIterators](#implementations).

=== [[initializeAggregateFunctions]] `initializeAggregateFunctions` Internal Method

[source, scala]
----
initializeAggregateFunctions(
  expressions: Seq[AggregateExpression],
  startingInputBufferOffset: Int): Array[AggregateFunction]
----

`initializeAggregateFunctions`...FIXME

NOTE: `initializeAggregateFunctions` is used when...FIXME

=== [[generateProcessRow]] `generateProcessRow` Internal Method

[source, scala]
----
generateProcessRow(
  expressions: Seq[AggregateExpression],
  functions: Seq[AggregateFunction],
  inputAttributes: Seq[Attribute]): (InternalRow, InternalRow) => Unit
----

`generateProcessRow`...FIXME

NOTE: `generateProcessRow` is used when...FIXME

=== [[generateResultProjection]] `generateResultProjection` Method

[source, scala]
----
generateResultProjection(): (UnsafeRow, InternalRow) => UnsafeRow
----

`generateResultProjection`...FIXME

[NOTE]
====
`generateResultProjection` is used when:

* `AggregationIterator` is <<generateOutput, created>>

* `TungstenAggregationIterator` is requested for the <<TungstenAggregationIterator.md#generateResultProjection, generateResultProjection>>
====
