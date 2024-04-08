# UserDefinedAggregator

`UserDefinedAggregator[IN, BUF, OUT]` is a [UserDefinedFunction](UserDefinedFunction.md) that uses [ScalaAggregator](ScalaAggregator.md) for execution.

`UserDefinedAggregator` is [created](#creating-instance) using [udaf](../standard-functions//index.md#udaf) standard function.

## Creating Instance

`UserDefinedAggregator` takes the following to be created:

* <span id="aggregator"> [Aggregator](Aggregator.md)
* <span id="inputEncoder"> [Encoder](../Encoder.md) (of `IN`s and [assumed an ExpressionEncoder](#scalaAggregator))
* <span id="name"> Name
* <span id="nullable"> `nullable` flag (default: `true`)
* <span id="deterministic"> `deterministic` flag (default: `true`)

`UserDefinedAggregator` is created using [udaf](../standard-functions//index.md#udaf) standard function.

## <span id="apply"> Creating Column (for Function Execution)

```scala
apply(
  exprs: Column*): Column
```

`apply` is part of the [UserDefinedFunction](UserDefinedFunction.md#apply) abstraction.

---

`apply` creates a [Column](../Column.md) with an [AggregateExpression](AggregateExpression.md) with the following:

* [ScalaAggregator](#scalaAggregator) aggregate function
* `Complete` aggregate mode
* `isDistinct` flag disabled (`false`)

## <span id="scalaAggregator"> Creating ScalaAggregator

```scala
scalaAggregator(
  exprs: Seq[Expression]): ScalaAggregator[IN, BUF, OUT]
```

`scalaAggregator` assumes the following are all [ExpressionEncoder](../ExpressionEncoder.md)s:

1. [Input Encoder](#inputEncoder) (of `IN`s)
1. [Buffer Encoder](Aggregator.md#bufferEncoder) (of `BUF`s) of the [Aggregator](#aggregator)

In the end, `scalaAggregator` creates a [ScalaAggregator](ScalaAggregator.md).

---

`scalaAggregator` is used when:

* `UDFRegistration` is requested to [register a UserDefinedAggregator](../user-defined-functions/UDFRegistration.md#register)
* `UserDefinedAggregator` is requested to [create a Column (for execution)](#apply)

## <span id="withName"> Creates Named UserDefinedAggregator

```scala
withName(
  name: String): UserDefinedAggregator[IN, BUF, OUT]
```

`withName` is part of the [UserDefinedFunction](UserDefinedFunction.md#withName) abstraction.

---

`withName` creates a copy of this `UserDefinedAggregator` to use the given `name` as the [name](#name).
