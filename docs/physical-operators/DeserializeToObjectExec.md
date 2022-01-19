# DeserializeToObjectExec

`DeserializeToObjectExec` is a [unary physical operator](UnaryExecNode.md) with [CodegenSupport](#CodegenSupport).

`DeserializeToObjectExec` is a [ObjectProducerExec](#ObjectProducerExec).

## Creating Instance

`DeserializeToObjectExec` takes the following to be created:

* <span id="deserializer"> Deserializer [Expression](../expressions/Expression.md)
* [Attribute](#outputObjAttr)
* <span id="child"> Child [physical operator](SparkPlan.md)

`DeserializeToObjectExec` is created when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (with a logical query with a [DeserializeToObject](../logical-operators/DeserializeToObject.md) logical operator)

## <span id="CodegenSupport"> CodegenSupport

`DeserializeToObjectExec` is a [CodegenSupport](CodegenSupport.md).

### <span id="doConsume"> doConsume

```scala
doConsume(
  ctx: CodegenContext,
  input: Seq[ExprCode], row: ExprCode): String
```

`doConsume`...FIXME

`doConsume` is part of the [CodegenSupport](CodegenSupport.md#doConsume) abstraction.

### <span id="doProduce"> doProduce

```scala
doProduce(
  ctx: CodegenContext): String
```

`doProduce`...FIXME

`doProduce` is part of the [CodegenSupport](CodegenSupport.md#doProduce) abstraction.

### <span id="inputRDDs"> inputRDDs

```scala
inputRDDs(): Seq[RDD[InternalRow]]
```

`inputRDDs` requests the [child](#child) (that is supposed to be a physical operator with [CodegenSupport](CodegenSupport.md)) for the [inputRDDs](CodegenSupport.md#inputRDDs).

`inputRDDs` is part of the [CodegenSupport](CodegenSupport.md#inputRDDs) abstraction.

## <span id="ObjectProducerExec"> ObjectProducerExec

`DeserializeToObjectExec` is an [ObjectProducerExec](ObjectProducerExec.md).

### <span id="outputObjAttr"> outputObjAttr

`DeserializeToObjectExec` is given an `outputObjAttr` when [created](#creating-instance).

`outputObjAttr` is part of the [ObjectProducerExec](ObjectProducerExec.md#outputObjAttr) abstraction.

## <span id="SparkPlan"> SparkPlan

`DeserializeToObjectExec` is a [SparkPlan](SparkPlan.md).

### <span id="doExecute"> Execution

```scala
doExecute(): RDD[InternalRow]
```

`doExecute`...FIXME

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.
