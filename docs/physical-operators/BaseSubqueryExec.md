# BaseSubqueryExec Physical Operators

`BaseSubqueryExec` is an [extension](#contract) of the [SparkPlan](SparkPlan.md) abstraction for [physical operators](#implementations) with a [child subquery plan](#child).

## Contract

### <span id="child"> Child Subquery Physical Plan

```scala
child: SparkPlan
```

[SparkPlan](SparkPlan.md) of the subquery

Used when:

* `BaseSubqueryExec` is requested to [output](#output), [outputPartitioning](#outputPartitioning) and [outputOrdering](#outputOrdering)
* `ExplainUtils` utility is used to [processPlan](../ExplainUtils.md#processPlan)

### <span id="name"> Name

```scala
name: String
```

Used when:

* `ReusedSubqueryExec` physical operator is requested for the [name](ReusedSubqueryExec.md#name)
* `InSubqueryExec` expression is requested for the [text representation](../expressions/InSubqueryExec.md#toString)

## Implementations

* [ReusedSubqueryExec](ReusedSubqueryExec.md)
* [SubqueryAdaptiveBroadcastExec](SubqueryAdaptiveBroadcastExec.md)
* [SubqueryBroadcastExec](SubqueryBroadcastExec.md)
* [SubqueryExec](SubqueryExec.md)

## <span id="generateTreeString"> Text Representation

```scala
generateTreeString(
  depth: Int,
  lastChildren: Seq[Boolean],
  append: String => Unit,
  verbose: Boolean,
  prefix: String = "",
  addSuffix: Boolean = false,
  maxFields: Int,
  printNodeId: Boolean): Unit
```

`generateTreeString`...FIXME

`generateTreeString` is part of the [TreeNode](../catalyst/TreeNode.md#generateTreeString) abstraction.
