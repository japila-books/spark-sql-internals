# RuleExecutors

`RuleExecutor` is an [abstraction](#contract) of [rule executors](#implementations) that can [execute batches of rules](#execute) (that transform [TreeNodes](TreeNode.md)).

## Contract

### <span id="batches"> Batches of Rules

```scala
batches: Seq[Batch]
```

A sequence of [batches of rules](#Batch)

Used when `RuleExecutor` is [executed](#execute)

## Implementations

* [Logical Adaptive Optimizer](../physical-operators/AdaptiveSparkPlanExec.md#optimizer)
* [Logical Analyzer](../Analyzer.md)
* `ExpressionCanonicalizer`
* [Logical Optimizers](Optimizer.md)

## <span id="execute"> Executing Batches of Rules

```scala
execute(
  plan: TreeType): TreeType
```

`execute` iterates over [rule batches](#batches) and applies rules sequentially to the input `plan`.

`execute` tracks the number of iterations and the time of executing each rule (with a plan).

When a rule changes a plan, you should see the following TRACE message in the logs:

```text
=== Applying Rule [ruleName] ===
[currentAndModifiedPlansSideBySide]
```

After the number of iterations has reached the number of iterations for the batch's `Strategy` it stops execution and prints out the following WARN message to the logs:

```text
Max iterations ([iteration]) reached for batch [batchName]
```

When the plan has not changed (after applying rules), you should see the following TRACE message in the logs and `execute` moves on to applying the rules in the next batch. The moment is called *fixed point* (i.e. when the execution *converges*).

```text
Fixed point reached for batch [batchName] after [iteration] iterations.
```

After the batch finishes, if the plan has been changed by the rules, you should see the following DEBUG message in the logs:

```text
=== Result of Batch [batchName] ===
[currentAndModifiedPlansSideBySide]
```

Otherwise, when the rules had no changes to a plan, you should see the following TRACE message in the logs:

```text
Batch [batchName] has no effect.
```

## <span id="executeAndTrack"> Tracking Time of Executing Batches of Rules

```scala
executeAndTrack(
  plan: TreeType,
  tracker: QueryPlanningTracker): TreeType
```

`executeAndTrack`...FIXME

`executeAndTrack` is used when:

* `Analyzer` is requested to [executeAndCheck](../Analyzer.md#executeAndCheck)
* `QueryExecution` is requested for the [optimized logical plan](../QueryExecution.md#optimizedPlan)

## <span id="blacklistedOnceBatches"> blacklistedOnceBatches

```scala
blacklistedOnceBatches: Set[String]
```

`blacklistedOnceBatches` is empty by default (`Set.empty`).

`blacklistedOnceBatches` is used when `RuleExecutor` is [executed](#execute).

## <span id="checkBatchIdempotence"> checkBatchIdempotence Internal Method

```scala
checkBatchIdempotence(
  batch: Batch,
  plan: TreeType): Unit
```

`checkBatchIdempotence`...FIXME

`checkBatchIdempotence` is used when `RuleExecutor` is [executed](#execute).

## <span id="isPlanIntegral"> isPlanIntegral

```scala
isPlanIntegral(
  plan: TreeType): Boolean
```

`isPlanIntegral` is `true` by default.

`isPlanIntegral` is used when `RuleExecutor` is [executed](#execute).

## Scala Definition

```scala
abstract class RuleExecutor[TreeType <: TreeNode[_]] {
  // body omitted
}
```

The definition of the `RuleExecutor` abstract class uses `TreeType` type parameter that is constrained by a upper type bound (`TreeNode[_]`). It says that `TreeType` type variable can only be a subtype of type [TreeNode](TreeNode.md).

!!! tip
    Read up on `<:` type operator in Scala in [Upper Type Bounds](https://docs.scala-lang.org/tour/upper-type-bounds.html).

## <span id="Batch"> Rule Batch &mdash; Collection of Rules

`Batch` is a named collection of [rules](Rule.md) with an [execution strategy](#Strategy).

`Batch` is defined by the following:

* <span id="name"> Batch Name
* <span id="strategy"> [Execution Strategy](#Strategy)
* <span id="rules"> Collection of [rules](Rule.md)

## <span id="Strategy"> Execution Strategy

`Strategy` is an abstraction of [execution strategies](#strategy-implementations).

### <span id="strategy-maxIterations"> maxIterations

```scala
maxIterations: Int
```

Used when...FIXME

### <span id="strategy-errorOnExceed"> errorOnExceed

```scala
errorOnExceed: Boolean = false
```

Used when...FIXME

### <span id="strategy-maxIterationsSetting"> maxIterationsSetting

```scala
maxIterationsSetting: String = null
```

Used when...FIXME

### <span id="strategy-implementations"> Implementations

#### FixedPoint

An [execution strategy](#Strategy) that runs until fix point (and converge) or `maxIterations` times, whichever comes first

#### Once

An [execution strategy](#Strategy) that runs only once (with `maxIterations` as `1`)
