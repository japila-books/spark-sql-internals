# Exchange Unary Physical Operators

`Exchange` is an [extension](#contract) of the [UnaryExecNode](UnaryExecNode.md) abstraction for [unary physical operators](#implementations) to exchange data (among tasks).

!!! note "Adaptive Query Execution"
    `Exchange` operators are target of [Adaptive Query Execution](../adaptive-query-execution/index.md).

## Implementations

* [BroadcastExchangeLike](BroadcastExchangeLike.md)
* [ShuffleExchangeLike](ShuffleExchangeLike.md)

## <span id="output"> Output Attributes

```scala
output: Seq[Attribute]
```

`output` is part of the [QueryPlan](../catalyst/QueryPlan.md#output) abstraction.

`output` requests the [child](UnaryExecNode.md#child) operator for the [output attributes](../catalyst/QueryPlan.md#output).

## <span id="stringArgs"> Arguments

```scala
stringArgs: Iterator[Any]
```

`stringArgs` is part of the [TreeNode](../catalyst/TreeNode.md#stringArgs) abstraction.

`stringArgs` adds **[id=#[id]]** to the default [stringArgs](../catalyst/TreeNode.md#stringArgs).
