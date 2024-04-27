# Aggregator Expressions

`Aggregator` is an [abstraction](#contract) of [typed user-defined aggregate functions](#implementations) (_user-defined typed aggregations_ or _UDAFs_).

```scala
abstract class Aggregator[-IN, BUF, OUT]
```

`Aggregator` is a `Serializable` ([Java]({{ java.api }}/java/lang/Serializable.html)).

`Aggregator` is registered using [udaf](../standard-functions/index.md#udaf) standard function.

## Contract

### <span id="bufferEncoder"> bufferEncoder

```scala
bufferEncoder: Encoder[BUF]
```

Used when:

* `Aggregator` is requested to [toColumn](#toColumn)
* `UserDefinedAggregator` is requested to [scalaAggregator](UserDefinedAggregator.md#scalaAggregator)

### <span id="finish"> finish

```scala
finish(
  reduction: BUF): OUT
```

Used when:

* `ComplexTypedAggregateExpression` is requested to `eval`
* `ScalaAggregator` is requested to [eval](ScalaAggregator.md#eval)

### <span id="merge"> merge

```scala
merge(
  b1: BUF,
  b2: BUF): BUF
```

Used when:

* `ComplexTypedAggregateExpression` is requested to `merge`
* `ScalaAggregator` is requested to [merge](ScalaAggregator.md#merge)

### <span id="outputEncoder"> outputEncoder

```scala
outputEncoder: Encoder[OUT]
```

Used when:

* `Aggregator` is requested to [toColumn](#toColumn)
* `ScalaAggregator` is requested for the [outputEncoder](ScalaAggregator.md#outputEncoder)

### <span id="reduce"> reduce

```scala
reduce(
  b: BUF,
  a: IN): BUF
```

Used when:

* `ComplexTypedAggregateExpression` is requested to `update`
* `ScalaAggregator` is requested to [update](ScalaAggregator.md#update)

### <span id="zero"> zero

```scala
zero: BUF
```

Used when:

* `SimpleTypedAggregateExpression` is requested for `initialValues`
* `ComplexTypedAggregateExpression` is requested to `createAggregationBuffer`
* `ScalaAggregator` is requested to [createAggregationBuffer](ScalaAggregator.md#createAggregationBuffer)

## Implementations

* `ReduceAggregator`
* `TypedAverage`
* `TypedCount`
* `TypedSumDouble`
* `TypedSumLong`

## <span id="toColumn"> Converting to TypedColumn

```scala
toColumn: TypedColumn[IN, OUT]
```

`toColumn` converts the `Aggregator` to a [TypedColumn](../TypedColumn.md) (that can be used with [Dataset.select](../spark-sql-dataset-operators.md#select) and [KeyValueGroupedDataset.agg](../KeyValueGroupedDataset.md#agg) typed operators).

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

Use `org.apache.spark.sql.expressions.scalalang.typed` object to access the type-safe aggregate functions (i.e. `avg`, `count`, `sum` and `sumLong`).

```scala
import org.apache.spark.sql.expressions.scalalang.typed
ds.groupByKey(_._1).agg(typed.sum(_._2))
ds.select(typed.sum((i: Int) => i))
```
