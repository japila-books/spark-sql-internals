# Aggregator Expressions

`Aggregator` is an [abstraction](#contract) of [typed user-defined aggregate functions](#implementations) (_user-defined typed aggregations_ or _UDAFs_).

```scala
abstract class Aggregator[-IN, BUF, OUT]
```

`Aggregator` is a `Serializable` ([Java]({{ java.api }}/java/lang/Serializable.html)).

## Contract

### <span id="bufferEncoder"> bufferEncoder

```scala
bufferEncoder: Encoder[BUF]
```

Used when:

* `Aggregator` is requested to [toColumn](#toColumn)
* `UserDefinedAggregator` is requested to `scalaAggregator`

### <span id="finish"> finish

```scala
finish(
  reduction: BUF): OUT
```

Used when:

* `ComplexTypedAggregateExpression` is requested to `eval`
* `ScalaAggregator` is requested to `eval`

### <span id="merge"> merge

```scala
merge(
  b1: BUF,
  b2: BUF): BUF
```

Used when:

* `ComplexTypedAggregateExpression` is requested to `merge`
* `ScalaAggregator` is requested to `merge`

### <span id="outputEncoder"> outputEncoder

```scala
outputEncoder: Encoder[OUT]
```

Used when:

* `ScalaAggregator` is requested for the `outputEncoder`
* `Aggregator` is requested to [toColumn](#toColumn)

### <span id="reduce"> reduce

```scala
reduce(
  b: BUF,
  a: IN): BUF
```

Used when:

* `ComplexTypedAggregateExpression` is requested to `update`
* `ScalaAggregator` is requested to `update`

### <span id="zero"> zero

```scala
zero: BUF
```

Used when:

* `SimpleTypedAggregateExpression` is requested for `initialValues`
* `ComplexTypedAggregateExpression` is requested to `createAggregationBuffer`
* `ScalaAggregator` is requested to `createAggregationBuffer`

## Implementations

* ReduceAggregator
* TypedAverage
* TypedCount
* TypedSumDouble
* TypedSumLong

## <span id="udaf"> udaf Standard Function

`udaf` standard function is used to register an `Aggregator` (create an `UserDefinedFunction` that wraps the given `Aggregator` so that it may be used with untyped Data Frames).

```scala
udaf[IN: TypeTag, BUF, OUT](
  agg: Aggregator[IN, BUF, OUT]): UserDefinedFunction
udaf[IN, BUF, OUT](
  agg: Aggregator[IN, BUF, OUT],
  inputEncoder: Encoder[IN]): UserDefinedFunction
```

## <span id="toColumn"> Converting to TypedColumn

```scala
toColumn: TypedColumn[IN, OUT]
```

`toColumn` converts the `Aggregator` to a [TypedColumn](../TypedColumn.md) (that can be used with [Dataset.select](../spark-sql-dataset-operators.md#select) and [KeyValueGroupedDataset.agg](../basic-aggregation/KeyValueGroupedDataset.md#agg) typed operators).

## Demo

```text
// From Spark MLlib's org.apache.spark.ml.recommendation.ALSModel
// Step 1. Create Aggregator
val topKAggregator: Aggregator[Int, Int, Float] = ???
val recs = ratings
  .as[(Int, Int, Float)]
  .groupByKey(_._1)
  .agg(topKAggregator.toColumn) // <-- use the custom Aggregator
  .toDF("id", "recommendations")
```

Use `org.apache.spark.sql.expressions.scalalang.typed` object to access the type-safe aggregate functions, i.e. `avg`, `count`, `sum` and `sumLong`.

```scala
import org.apache.spark.sql.expressions.scalalang.typed
```

```scala
ds.groupByKey(_._1).agg(typed.sum(_._2))
```

```scala
ds.select(typed.sum((i: Int) => i))
```
