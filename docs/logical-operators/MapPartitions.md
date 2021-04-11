# MapPartitions Unary Logical Operator

`MapPartitions` is a [unary logical operator](LogicalPlan.md#UnaryNode) to represent [Dataset.mapPartitions](../Dataset.md#mapPartitions) operator.

`MapPartitions` is an [ObjectConsumer](ObjectConsumer.md) and an [ObjectProducer](ObjectProducer.md).

## Creating Instance

`MapPartitions` takes the following to be created:

* <span id="func"> Map Partitions Function (`Iterator[Any] => Iterator[Any]`)
* <span id="outputObjAttr"> Output Object [Attribute](../expressions/Attribute.md)
* <span id="child"> Child [Logical Plan](LogicalPlan.md)

`MapPartitions` is created (indirectly using [apply](#apply) utility) when:

* [Dataset.mapPartitions](../Dataset.md#mapPartitions) operator is used

## Execution Planning

`MapPartitions` is planned as [MapPartitionsExec](../physical-operators/MapPartitionsExec.md) physical operator when [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed.

## <span id="apply"> Creating MapPartitions

```scala
apply[T : Encoder, U : Encoder](
  func: Iterator[T] => Iterator[U],
  child: LogicalPlan): LogicalPlan
```

`apply` [creates a deserializer](../CatalystSerde.md#deserialize) (for the type `T` of the input objects) and uses it to create a [MapPartitions](#creating-instance).

In the end, `apply` [creates a serializer](../CatalystSerde.md#serialize) (for the type `U` of the output objects) with the `MapPartitions` as the child.

`apply` is used when:

* [Dataset.mapPartitions](../Dataset.md#mapPartitions) operator is used
