# ExecutedCommandExec Physical Operator

`ExecutedCommandExec` is a [leaf physical operator](LeafExecNode.md) for executing [runnable logical commands](../logical-operators/RunnableCommand.md).

## Creating Instance

`ExecutedCommandExec` takes the following to be created:

* <span id="cmd"> [RunnableCommand](../logical-operators/RunnableCommand.md)

`ExecutedCommandExec` is created when [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (for [RunnableCommand](../logical-operators/RunnableCommand.md) logical operators).

## <span id="nodeName"> Node Name

```scala
nodeName: String
```

`nodeName` is the following (using the [node name](../catalyst/TreeNode.md#nodeName) of the [RunnableCommand](#cmd)):

```text
Execute [nodeName]
```

`nodeName` is part of the [TreeNode](../catalyst/TreeNode.md#nodeName) abstraction.

## <span id="executeCollect"><span id="executeToIterator"><span id="executeTake"><span id="executeTail"><span id="doExecute"> Executing Command

As a [physical operator](SparkPlan.md), `ExecutedCommandExec` use the [sideEffectResult](#sideEffectResult) for execution:

* [executeCollect](SparkPlan.md#executeCollect)
* [executeToIterator](SparkPlan.md#executeToIterator)
* [executeTake](SparkPlan.md#executeTake)
* [executeTail](SparkPlan.md#executeTail)
* [doExecute](SparkPlan.md#doExecute)

## <span id="sideEffectResult"> Side Effect of Executing Command

```scala
sideEffectResult: Seq[InternalRow]
```

`sideEffectResult` [creates a Catalyst converter](../CatalystTypeConverters.md#createToCatalystConverter) for the [schema](../catalyst/QueryPlan.md#schema).

`sideEffectResult` requests the [RunnableCommand](#cmd) to [execute](../logical-operators/RunnableCommand.md#run) and maps over the result using the Catalyst converter.

??? note "Lazy Value"
    `sideEffectResult` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and cached afterwards.

`sideEffectResult` is used for [executeCollect](#executeCollect), [executeToIterator](#executeToIterator), [executeTake](#executeTake), [executeTail](#executeTail), and [doExecute](#doExecute).
