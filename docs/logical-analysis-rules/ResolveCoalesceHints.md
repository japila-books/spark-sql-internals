# ResolveCoalesceHints Logical Resolution Rule

`ResolveCoalesceHints` is a logical resolution rule to [resolve UnresolvedHint logical operators](#apply) with the following hint names:

Hint Name | Arguments | Logical Operator
----------|-----------|-----------------
 `COALESCE` | Number of partitions | [Repartition](../logical-operators/RepartitionOperation.md#Repartition) (with `shuffle` off / `false`)
 `REBALANCE` | | [RebalancePartitions](../logical-operators/RebalancePartitions.md)
 `REPARTITION` | Number of partitions alone or like `REPARTITION_BY_RANGE` | [Repartition](../logical-operators/RepartitionOperation.md#Repartition) (with `shuffle` on / `true`)
 `REPARTITION_BY_RANGE` | Column names with an optional number of partitions (default: [spark.sql.shuffle.partitions](../configuration-properties.md#spark.sql.shuffle.partitions) configuration property) | [RepartitionByExpression](../logical-operators/RepartitionByExpression.md)

`ResolveCoalesceHints` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

`ResolveCoalesceHints` is part of [Hints](../Analyzer.md#Hints) batch of rules of [Logical Analyzer](../Analyzer.md).

## Creating Instance

`ResolveCoalesceHints` takes the following to be created:

* <span id="conf"> [SQLConf](../SQLConf.md)

`ResolveCoalesceHints` is created when [Logical Analyzer](../Analyzer.md) is requested for the [batches of rules](../Analyzer.md#batches).

## Executing Rule { #apply }

??? note "Rule"

    ```scala
    apply(
      plan: LogicalPlan): LogicalPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` resolves [UnresolvedHint](../logical-operators/UnresolvedHint.md) logical operators with the following hint names (case-insensitive).

Hint Name | Trigger
----------|----------
 `COALESCE` | [createRepartition](#createRepartition) (with `shuffle` off)
 `REBALANCE` | [createRebalance](#createRebalance)
 `REPARTITION` | [createRepartition](#createRepartition) (with `shuffle` on)
 `REPARTITION_BY_RANGE` | [createRepartitionByRange](#createRepartitionByRange)

### <span id="createRebalance"> createRebalance

```scala
createRebalance(
  hint: UnresolvedHint): LogicalPlan
```

`createRebalance` handles a `REBALANCE` hint and creates a [Repartition](../logical-operators/RebalancePartitions.md) logical operator.

### <span id="createRepartition"> createRepartition

```scala
createRepartition(
  shuffle: Boolean,
  hint: UnresolvedHint): LogicalPlan
```

`createRepartition` handles `COALESCE` and `REPARTITION` hints (and creates [Repartition](../logical-operators/RepartitionOperation.md#Repartition) or [RepartitionByExpression](../logical-operators/RepartitionByExpression.md) logical operators).

### <span id="createRepartitionByRange"> createRepartitionByRange

```scala
createRepartitionByRange(
  hint: UnresolvedHint): RepartitionByExpression
```

`createRepartitionByRange` creates a [RepartitionByExpression](../logical-operators/RepartitionByExpression.md) logical operator.

## Examples

### Using COALESCE Hint

```text
// Use Catalyst DSL to create a logical plan
import org.apache.spark.sql.catalyst.dsl.plans._
val plan = table("t1").hint(name = "COALESCE", 3)
scala> println(plan.numberedTreeString)
00 'UnresolvedHint COALESCE, [3]
01 +- 'UnresolvedRelation `t1`

import org.apache.spark.sql.catalyst.analysis.ResolveHints.ResolveCoalesceHints
val analyzedPlan = ResolveCoalesceHints(plan)
scala> println(analyzedPlan.numberedTreeString)
00 'Repartition 3, false
01 +- 'UnresolvedRelation `t1`
```

### Using REPARTITION Hint

```text
// Use Catalyst DSL to create a logical plan
import org.apache.spark.sql.catalyst.dsl.plans._
val plan = table("t1").hint(name = "REPARTITION", 3)
scala> println(plan.numberedTreeString)
00 'UnresolvedHint REPARTITION, [3]
01 +- 'UnresolvedRelation `t1`

import org.apache.spark.sql.catalyst.analysis.ResolveHints.ResolveCoalesceHints
val analyzedPlan = ResolveCoalesceHints(plan)
scala> println(analyzedPlan.numberedTreeString)
00 'Repartition 3, true
01 +- 'UnresolvedRelation `t1`
```

### Using COALESCE Hint in SQL

```text
val q = sql("SELECT /*+ COALESCE(10) */ * FROM VALUES 1 t(id)")
val plan = q.queryExecution.logical
scala> println(plan.numberedTreeString)
00 'UnresolvedHint COALESCE, [10]
01 +- 'Project [*]
02    +- 'SubqueryAlias `t`
03       +- 'UnresolvedInlineTable [id], [List(1)]

import org.apache.spark.sql.catalyst.analysis.ResolveHints.ResolveCoalesceHints
val analyzedPlan = ResolveCoalesceHints(plan)
scala> println(analyzedPlan.numberedTreeString)
00 'Repartition 10, false
01 +- 'Project [*]
02    +- 'SubqueryAlias `t`
03       +- 'UnresolvedInlineTable [id], [List(1)]
```
