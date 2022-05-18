# DataWritingCommandExec Physical Operator

`DataWritingCommandExec` is a [UnaryExecNode](UnaryExecNode.md) that is the execution environment for a [DataWritingCommand](#cmd) logical command at [execution time](#doExecute).

## Creating Instance

`DataWritingCommandExec` takes the following to be created:

* <span id="cmd"> [DataWritingCommand](../logical-operators/DataWritingCommand.md)
* <span id="child"> Child [SparkPlan](SparkPlan.md)

`DataWritingCommandExec` is created when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is requested to plan a [DataWritingCommand](../logical-operators/DataWritingCommand.md) logical command

## <span id="metrics"> Performance Metrics

```scala
metrics: Map[String, SQLMetric]
```

`metrics` requests the [DataWritingCommand](#cmd) for the [metrics](../logical-operators/DataWritingCommand.md#metrics).

`metrics` is part of the [SparkPlan](SparkPlan.md#metrics) abstraction.

## <span id="sideEffectResult"> sideEffectResult

```scala
sideEffectResult: Seq[InternalRow]
```

??? note "Lazy Value"
    `sideEffectResult` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`sideEffectResult` requests the [DataWritingCommand](#cmd) to [run](../logical-operators/DataWritingCommand.md#run) (with the [active SparkSession](SparkPlan.md#session) and the [child](#child) logical operator) that produces output [Row](../Row.md)s.

In the end, `sideEffectResult` [creates a Catalyst converter](../CatalystTypeConverters.md#createToCatalystConverter) (for the [schema](../catalyst/QueryPlan.md#schema)) to convert the output rows.

Used when:

* `DataWritingCommandExec` is requested to [executeCollect](#executeCollect), [executeToIterator](#executeToIterator), [executeTake](#executeTake), [executeTail](#executeTail) and [doExecute](#doExecute)

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` requests the [SparkPlan](SparkPlan.md#sparkContext) to `parallelize` the [sideEffectResult](#sideEffectResult) (with `1` partition).

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.
