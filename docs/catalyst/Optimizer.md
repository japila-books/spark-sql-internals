# Optimizer &mdash; Generic Logical Query Plan Optimizer

`Optimizer` (**Catalyst Optimizer**) is an extension of the [RuleExecutor](RuleExecutor.md) abstraction for [logical query plan optimizers](#implementations).

```text
Optimizer: Analyzed Logical Plan ==> Optimized Logical Plan
```

## Implementations

* [SparkOptimizer](../SparkOptimizer.md)

## Creating Instance

`Optimizer` takes the following to be created:

* <span id="catalogManager"> [CatalogManager](../connector/catalog/CatalogManager.md)

`Optimizer` is an abstract class and cannot be created directly. It is created indirectly for the [concrete Optimizers](#implementations).

## <span id="defaultBatches"> Default Batches

`Optimizer` defines the **default rule batches of logical optimizations** that transform the query plan of a structured query to produce the [optimized logical query plan](../QueryExecution.md#optimizedPlan).

The default rule batches can be further refined (extended or with [rules excluded](#excludedRules)).

### Eliminate Distinct

Rules:

* EliminateDistinct

Strategy: `Once`

### <span id="Finish-Analysis"> Finish Analysis

Rules:

* [EliminateResolvedHint](../logical-optimizations/EliminateResolvedHint.md)
* EliminateSubqueryAliases
* EliminateView
* [InlineCTE](../logical-optimizations/InlineCTE.md)
* ReplaceExpressions
* RewriteNonCorrelatedExists
* PullOutGroupingExpressions
* [ComputeCurrentTime](../logical-optimizations/ComputeCurrentTime.md)
* ReplaceCurrentLike

Strategy: `Once`

### Union

Rules:

* [CombineUnions](../logical-optimizations/CombineUnions.md)

Strategy: `Once`

### OptimizeLimitZero

Rules:

* OptimizeLimitZero

Strategy: `Once`

### LocalRelation early

Rules:

* ConvertToLocalRelation
* [PropagateEmptyRelation](../logical-optimizations/PropagateEmptyRelation.md)

Strategy: fixedPoint

### Pullup Correlated Expressions

Rules:

* [PullupCorrelatedPredicates](../logical-optimizations/PullupCorrelatedPredicates.md)

Strategy: `Once`

### Subquery

Rules:

* [OptimizeSubqueries](../logical-optimizations/OptimizeSubqueries.md)

Strategy: `FixedPoint(1)`

### Replace Operators

Rules:

* RewriteExceptAll
* RewriteIntersectAll
* ReplaceIntersectWithSemiJoin
* ReplaceExceptWithFilter
* ReplaceExceptWithAntiJoin
* ReplaceDistinctWithAggregate

Strategy: fixedPoint

### Aggregate

Rules:

* RemoveLiteralFromGroupExpressions
* RemoveRepetitionFromGroupExpressions

Strategy: fixedPoint

### Operator Optimization before Inferring Filters

Rules:

* PushProjectionThroughUnion
* ReorderJoin
* EliminateOuterJoin
* PushDownPredicates
* PushDownLeftSemiAntiJoin
* PushLeftSemiLeftAntiThroughJoin
* [LimitPushDown](../logical-optimizations/LimitPushDown.md)
* ColumnPruning
* CollapseRepartition
* CollapseProject
* CollapseWindow
* CombineFilters
* CombineLimits
* CombineUnions
* TransposeWindow
* NullPropagation
* ConstantPropagation
* FoldablePropagation
* OptimizeIn
* ConstantFolding
* ReorderAssociativeOperator
* LikeSimplification
* BooleanSimplification
* SimplifyConditionals
* RemoveDispensableExpressions
* SimplifyBinaryComparison
* ReplaceNullWithFalseInPredicate
* PruneFilters
* SimplifyCasts
* SimplifyCaseConversionExpressions
* RewriteCorrelatedScalarSubquery
* EliminateSerialization
* RemoveRedundantAliases
* RemoveNoopOperators
* SimplifyExtractValueOps
* CombineConcats
* [extendedOperatorOptimizationRules](#extendedOperatorOptimizationRules)

Strategy: `fixedPoint`

### Infer Filters

Rules:

* [InferFiltersFromConstraints](../logical-optimizations/InferFiltersFromConstraints.md)

Strategy: `Once`

### Operator Optimization after Inferring Filters

Rules:

* The same as in [Operator Optimization before Inferring Filters](#operator-optimization-before-inferring-filters) batch

Strategy: `fixedPoint`

### Early Filter and Projection Push-Down

Rules:

* As defined by the [earlyScanPushDownRules](#earlyScanPushDownRules) extension point

Strategy: `Once`

### <span id="Update-CTE-Relation-Stats"> Update CTE Relation Stats

Rules:

* [UpdateCTERelationStats](../logical-optimizations/UpdateCTERelationStats.md)

Strategy: `Once`

### Join Reorder

Rules:

* [CostBasedJoinReorder](../logical-optimizations/CostBasedJoinReorder.md)

Strategy: `FixedPoint(1)`

### Eliminate Sorts

Rules:

* EliminateSorts

Strategy: `Once`

### Decimal Optimizations

Rules:

* [DecimalAggregates](../logical-optimizations/DecimalAggregates.md)

Strategy: `fixedPoint`

### Object Expressions Optimization

Rules:

* EliminateMapObjects
* CombineTypedFilters
* ObjectSerializerPruning
* ReassignLambdaVariableID

Strategy: `fixedPoint`

### LocalRelation

Rules:

* ConvertToLocalRelation
* [PropagateEmptyRelation](../logical-optimizations/PropagateEmptyRelation.md)

Strategy: `fixedPoint`

### Check Cartesian Products

Rules:

* CheckCartesianProducts

Strategy: `Once`

### RewriteSubquery

Rules:

* [RewritePredicateSubquery](../logical-optimizations/RewritePredicateSubquery.md)
* [ColumnPruning](../logical-optimizations/ColumnPruning.md)
* CollapseProject
* RemoveNoopOperators

Strategy: `Once`

### NormalizeFloatingNumbers

Rules:

* NormalizeFloatingNumbers

Strategy: `Once`

## <span id="excludedRules"><span id="spark.sql.optimizer.excludedRules"> Excluded Rules

`Optimizer` uses [spark.sql.optimizer.excludedRules](../configuration-properties.md#spark.sql.optimizer.excludedRules) configuration property to control what rules in the [defaultBatches](#defaultBatches) to exclude.

## <span id="nonExcludableRules"> Non-Excludable Rules

`Optimizer` considers some optimization rules as **non-excludable** and necessary for correctness. They are considered so critical for query optimization that can never be excluded (even using [spark.sql.optimizer.excludedRules](#spark.sql.optimizer.excludedRules) configuration property).

* EliminateDistinct
* EliminateResolvedHint
* EliminateSubqueryAliases
* EliminateView
* ReplaceExpressions
* ComputeCurrentTime
* GetCurrentDatabase
* RewriteDistinctAggregates
* ReplaceDeduplicateWithAggregate
* ReplaceIntersectWithSemiJoin
* ReplaceExceptWithFilter
* ReplaceExceptWithAntiJoin
* RewriteExceptAll
* RewriteIntersectAll
* ReplaceDistinctWithAggregate
* PullupCorrelatedPredicates
* RewriteCorrelatedScalarSubquery
* RewritePredicateSubquery
* NormalizeFloatingNumbers

## Accessing Optimizer

`Optimizer` is available as the [optimizer](../SessionState.md#optimizer) property of a session-specific `SessionState`.

```text
scala> :type spark
org.apache.spark.sql.SparkSession

scala> :type spark.sessionState.optimizer
org.apache.spark.sql.catalyst.optimizer.Optimizer
```

You can access the optimized logical plan of a structured query (as a [Dataset](../Dataset.md)) using [Dataset.explain](../spark-sql-dataset-operators.md#explain) basic action (with `extended` flag enabled) or SQL's `EXPLAIN EXTENDED` SQL command.

```text
// sample structured query
val inventory = spark
  .range(5)
  .withColumn("new_column", 'id + 5 as "plus5")

// Using explain operator (with extended flag enabled)
scala> inventory.explain(extended = true)
== Parsed Logical Plan ==
'Project [id#0L, ('id + 5) AS plus5#2 AS new_column#3]
+- AnalysisBarrier
      +- Range (0, 5, step=1, splits=Some(8))

== Analyzed Logical Plan ==
id: bigint, new_column: bigint
Project [id#0L, (id#0L + cast(5 as bigint)) AS new_column#3L]
+- Range (0, 5, step=1, splits=Some(8))

== Optimized Logical Plan ==
Project [id#0L, (id#0L + 5) AS new_column#3L]
+- Range (0, 5, step=1, splits=Some(8))

== Physical Plan ==
*(1) Project [id#0L, (id#0L + 5) AS new_column#3L]
+- *(1) Range (0, 5, step=1, splits=8)
```

Alternatively, you can access the analyzed logical plan using `QueryExecution` and its [optimizedPlan](../QueryExecution.md#optimizedPlan) property  (that together with `numberedTreeString` method is a very good "debugging" tool).

```text
val optimizedPlan = inventory.queryExecution.optimizedPlan
scala> println(optimizedPlan.numberedTreeString)
00 Project [id#0L, (id#0L + 5) AS new_column#3L]
01 +- Range (0, 5, step=1, splits=Some(8))
```

## <span id="fixedPoint"> FixedPoint Strategy

`FixedPoint` strategy with the number of iterations as defined by [spark.sql.optimizer.maxIterations](../configuration-properties.md#spark.sql.optimizer.maxIterations) configuration property.

## <span id="extendedOperatorOptimizationRules"> Extended Operator Optimization Rules (Extension Point)

```scala
extendedOperatorOptimizationRules: Seq[Rule[LogicalPlan]] = Nil
```

`extendedOperatorOptimizationRules` extension point defines additional rules for the Operator Optimization rule batch.

`extendedOperatorOptimizationRules` rules are executed right after [Operator Optimization before Inferring Filters](#Operator-Optimization-before-Inferring-Filters) and [Operator Optimization after Inferring Filters](#Operator-Optimization-after-Inferring-Filters).

`extendedOperatorOptimizationRules` is used when...FIXME

## <span id="earlyScanPushDownRules"> earlyScanPushDownRules (Extension Point)

```scala
earlyScanPushDownRules: Seq[Rule[LogicalPlan]] = Nil
```

`earlyScanPushDownRules` extension point...FIXME

`earlyScanPushDownRules` is used when...FIXME

## <span id="blacklistedOnceBatches"> blacklistedOnceBatches

```scala
blacklistedOnceBatches: Set[String]
```

`blacklistedOnceBatches`...FIXME

`blacklistedOnceBatches` is used when...FIXME

## Batches

```scala
batches: Seq[Batch]
```

`batches` uses [spark.sql.optimizer.excludedRules](../configuration-properties.md#spark.sql.optimizer.excludedRules) configuration property for the rules to be excluded.

`batches` filters out [non-excludable rules](#nonExcludableRules) from the rules to be excluded. For any filtered-out rule, `batches` prints out the following WARN message to the logs:

```text
Optimization rule '[ruleName]' was not excluded from the optimizer because this rule is a non-excludable rule.
```

`batches` filters out the excluded rules from all [defaultBatches](#defaultBatches). In case a batch is left with no rules, `batches` prints out the following INFO message to the logs:

```text
Optimization batch '[name]' is excluded from the optimizer as all enclosed rules have been excluded.
```

`batches` is part of the [RuleExecutor](RuleExecutor.md#batches) abstraction.
