# Exchange Unary Physical Operators

`Exchange` is an [extension](#contract) of the [UnaryExecNode](SparkPlan.md#UnaryExecNode) abstraction for [unary physical operators](#implementations) to exchange data (among tasks).

!!! note "Adaptive Query Execution"
    `Exchange` operators are target of [Adaptive Query Execution](../new-and-noteworthy/adaptive-query-execution.md).

## Implementations

* [BroadcastExchangeExec](BroadcastExchangeExec.md)
* [ShuffleExchangeExec](ShuffleExchangeExec.md)

## Output Attributes

<span id="output">
```scala
output: Seq[Attribute]
```

`output` requests the [child](UnaryExecNode.md#child) operator for the [output attributes](../catalyst/QueryPlan.md#output).

`output` is part of the [QueryPlan](../catalyst/QueryPlan.md#output) abstraction.

## Arguments

<span id="stringArgs">
```scala
stringArgs: Iterator[Any]
```

`stringArgs` adds **[id=#[id]]** to the default [stringArgs](../catalyst/TreeNode.md#stringArgs).

`stringArgs` is part of the [TreeNode](../catalyst/TreeNode.md#stringArgs) abstraction.
