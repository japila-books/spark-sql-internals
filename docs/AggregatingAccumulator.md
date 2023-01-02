# AggregatingAccumulator

`AggregatingAccumulator` is an `AccumulatorV2` ([Spark Core]({{ book.spark_core }}/accumulators/AccumulatorV2)) for [CollectMetricsExec](physical-operators/CollectMetricsExec.md#accumulator) physical operator.

`AggregatingAccumulator` accumulates [InternalRow](InternalRow.md)s to produce an [InternalRow](InternalRow.md).

```scala
AccumulatorV2[InternalRow, InternalRow]
```

## Creating Instance

`AggregatingAccumulator` takes the following to be created:

* <span id="bufferSchema"> Buffer Schema ([DataType](types/DataType.md)s)
* <span id="initialValues"> Initial Values [Expression](expressions/Expression.md)s
* <span id="updateExpressions"> Update [Expression](expressions/Expression.md)s
* <span id="mergeExpressions"> Merge [Expression](expressions/Expression.md)s
* <span id="resultExpressions"> Result [Expression](expressions/Expression.md)s
* <span id="imperatives"> [ImperativeAggregate](expressions/ImperativeAggregate.md)s
* <span id="typedImperatives"> [TypedImperativeAggregate](expressions/TypedImperativeAggregate.md)s
* <span id="conf"> [SQLConf](SQLConf.md)

`AggregatingAccumulator` is created using [apply](#apply) and [copyAndReset](#copyAndReset).

## <span id="apply"> Creating AggregatingAccumulator

```scala
apply(
  functions: Seq[Expression],
  inputAttributes: Seq[Attribute]): AggregatingAccumulator
```

`apply`...FIXME

---

`apply` is used when:

* `CollectMetricsExec` physical operator is requested the [accumulator](physical-operators/CollectMetricsExec.md#accumulator)

## <span id="copyAndReset"> copyAndReset

```scala
copyAndReset(): AggregatingAccumulator
```

`copyAndReset` is part of the `AccumulatorV2` ([Spark Core]({{ book.spark_core }}/accumulators/AccumulatorV2#copyAndReset)) abstraction.

---

`copyAndReset`...FIXME
