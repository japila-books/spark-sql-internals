---
title: MapPartitions
---

# MapPartitions Unary Logical Operator

`MapPartitions` is a [unary logical operator](LogicalPlan.md#UnaryNode) to represent [Dataset.mapPartitions](../Dataset.md#mapPartitions) operator in a logical query plan.

`MapPartitions` is an `ObjectConsumer` and an `ObjectProducer`.

## Creating Instance

`MapPartitions` takes the following to be created:

* <span id="func"> Map Partitions Function (`Iterator[Any] => Iterator[Any]`)
* <span id="outputObjAttr"> Output Object [Attribute](../expressions/Attribute.md)
* <span id="child"> Child [Logical Plan](LogicalPlan.md)

`MapPartitions` is created (indirectly using [apply](#apply) utility) when:

* [Dataset.mapPartitions](../Dataset.md#mapPartitions) operator is used

## Query Planning

`MapPartitions` is planned as `MapPartitionsExec` physical operator when [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed.

## Creating MapPartitions { #apply }

```scala
apply[T : Encoder, U : Encoder](
  func: Iterator[T] => Iterator[U],
  child: LogicalPlan): LogicalPlan
```

`apply` creates a [MapPartitions](#creating-instance) unary logical operator with a [DeserializeToObject](../CatalystSerde.md#deserialize) child (for the type `T` of the input objects) and a [SerializeFromObject](../CatalystSerde.md#serialize) parent (for the type `U` of the output objects).

`apply` is used when:

* [Dataset.mapPartitions](../Dataset.md#mapPartitions) operator is used

## Demo

```text
val ds = spark.range(5)
val fn: Iterator[Long] => Iterator[String] = { ns =>
  ns.map { n =>
    if (n % 2 == 0) {
      s"even ($n)"
    } else {
      s"odd ($n)"
    }
  }
}
ds.mapPartitions(fn) // FIXME That does not seem to work!
```
