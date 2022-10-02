# FlatMapGroupsWithState Logical Operator

`FlatMapGroupsWithState` is a [binary logical operator](#BinaryNode) that represents the following [KeyValueGroupedDataset](../basic-aggregation/KeyValueGroupedDataset.md) high-level operators:

* [mapGroupsWithState](../basic-aggregation/KeyValueGroupedDataset.md#mapGroupsWithState)
* [flatMapGroupsWithState](../basic-aggregation/KeyValueGroupedDataset.md#flatMapGroupsWithState)

## <span id="BinaryNode"> BinaryNode

`FlatMapGroupsWithState` is a [binary logical operator](LogicalPlan.md#BinaryNode) with two child operators:

* The [child](#child) as the left operator
* The [initialState](#initialState) as the right operator

## <span id="ObjectProducer"> ObjectProducer

`FlatMapGroupsWithState` is an `ObjectProducer`.

## Creating Instance

`FlatMapGroupsWithState` takes the following to be created:

* <span id="func"> State Mapping Function (`(Any, Iterator[Any], LogicalGroupState[Any]) => Iterator[Any]`)
* <span id="keyDeserializer"> Key Deserializer [Expression](../expressions/Expression.md)
* <span id="valueDeserializer"> Value Deserializer [Expression](../expressions/Expression.md)
* <span id="groupingAttributes"> Grouping [Attribute](../expressions/Attribute.md)s
* <span id="dataAttributes"> Data [Attribute](../expressions/Attribute.md)s
* <span id="outputObjAttr"> Output Object [Attribute](../expressions/Attribute.md)
* <span id="stateEncoder"> State [ExpressionEncoder](../ExpressionEncoder.md)
* <span id="outputMode"> `OutputMode`
* <span id="isMapGroupsWithState"> `isMapGroupsWithState` flag (default: `false`)
* <span id="timeout"> `GroupStateTimeout`
* <span id="hasInitialState"> `hasInitialState` flag (default: `false`)
* <span id="initialStateGroupAttrs"> Initial State Group [Attribute](../expressions/Attribute.md)s
* <span id="initialStateDataAttrs"> Initial State Data [Attribute](../expressions/Attribute.md)s
* <span id="initialStateDeserializer"> Initial State Deserializer [Expression](../expressions/Expression.md)
* <span id="initialState"> Initial State [LogicalPlan](LogicalPlan.md)
* <span id="child"> Child [LogicalPlan](LogicalPlan.md)

`FlatMapGroupsWithState` is created using [apply](#apply) factory.

## <span id="apply"> Creating FlatMapGroupsWithState

```scala
apply[K: Encoder, V: Encoder, S: Encoder, U: Encoder](
  func: (Any, Iterator[Any], LogicalGroupState[Any]) => Iterator[Any],
  groupingAttributes: Seq[Attribute],
  dataAttributes: Seq[Attribute],
  outputMode: OutputMode,
  isMapGroupsWithState: Boolean,
  timeout: GroupStateTimeout,
  child: LogicalPlan): LogicalPlan
apply[K: Encoder, V: Encoder, S: Encoder, U: Encoder](
  func: (Any, Iterator[Any], LogicalGroupState[Any]) => Iterator[Any],
  groupingAttributes: Seq[Attribute],
  dataAttributes: Seq[Attribute],
  outputMode: OutputMode,
  isMapGroupsWithState: Boolean,
  timeout: GroupStateTimeout,
  child: LogicalPlan,
  initialStateGroupAttrs: Seq[Attribute],
  initialStateDataAttrs: Seq[Attribute],
  initialState: LogicalPlan): LogicalPlan
```

`apply` creates a [FlatMapGroupsWithState](#creating-instance) with the following:

* `UnresolvedDeserializer`s for the [keys](#keyDeserializer), [values](#valueDeserializer) and the [initial state](#initialStateDeserializer)
* [Generates](../CatalystSerde.md#generateObjAttr) the [output object attribute](#outputObjAttr)

In the end, `apply` [creates a SerializeFromObject unary logical operator](../CatalystSerde.md#serialize) with the `FlatMapGroupsWithState` operator as the child.

---

`apply` is used for the following high-level operators:

* [KeyValueGroupedDataset.mapGroupsWithState](../basic-aggregation/KeyValueGroupedDataset.md#mapGroupsWithState)
* [KeyValueGroupedDataset.flatMapGroupsWithState](../basic-aggregation/KeyValueGroupedDataset.md#flatMapGroupsWithState)

## Execution Planning

`FlatMapGroupsWithState` is planed as follows:

Physical Operator | Execution Planning Strategy
------------------|----------------------------
 `FlatMapGroupsWithStateExec` ([Spark Structured Streaming]({{ book.structured_streaming }}/physical-operators/FlatMapGroupsWithStateExec)) | `FlatMapGroupsWithStateStrategy` ([Spark Structured Streaming]({{ book.structured_streaming }}/execution-planning-strategies/FlatMapGroupsWithStateStrategy))
 `CoGroupExec` or `MapGroupsExec` | [BasicOperators](../execution-planning-strategies/BasicOperators.md)
