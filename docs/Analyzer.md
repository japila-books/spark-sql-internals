# Analyzer &mdash; Logical Query Plan Analyzer

`Analyzer` (aka _Spark Analyzer_ or _Query Analyzer_) is the **logical query plan analyzer** that [validates and transforms an unresolved logical plan](#execute) to an **analyzed logical plan**.

`Analyzer` is a [RuleExecutor](catalyst/RuleExecutor.md) of rules that transform [logical operators](logical-operators/LogicalPlan.md) (`RuleExecutor[LogicalPlan]`).

```text
Analyzer: Unresolved Logical Plan ==> Analyzed Logical Plan
```

`Analyzer` is used by `QueryExecution` to [resolve the managed `LogicalPlan`](QueryExecution.md#analyzed) (and, as a sort of follow-up, [assert that a structured query has already been properly analyzed](QueryExecution.md#assertAnalyzed), i.e. no failed or unresolved or somehow broken logical plan operators and expressions exist).

## <span id="extendedResolutionRules"> extendedResolutionRules Extension Point

```scala
extendedResolutionRules: Seq[Rule[LogicalPlan]] = Nil
```

`extendedResolutionRules` is an extension point for additional logical evaluation [rules](catalyst/Rule.md) for [Resolution](#Resolution) batch. The rules are added at the end of the `Resolution` batch.

Default: empty

!!! note
    [SessionState](SessionState.md) uses its own `Analyzer` with custom [extendedResolutionRules](#extendedResolutionRules), [postHocResolutionRules](#postHocResolutionRules), and [extendedCheckRules](#extendedCheckRules) extension methods.

## <span id="postHocResolutionRules"> postHocResolutionRules Extension Point

```scala
postHocResolutionRules: Seq[Rule[LogicalPlan]] = Nil
```

`postHocResolutionRules` is an extension point for [rules](catalyst/Rule.md) in [Post-Hoc Resolution](#post-hoc-resolution) batch if defined (that are executed in one pass, i.e. `Once` strategy).

Default: empty

## Batches

### Hints

Rules:

* ResolveJoinStrategyHints
* [ResolveCoalesceHints](logical-analysis-rules/ResolveCoalesceHints.md)

Strategy: [fixedPoint](#fixedPoint)

### Simple Sanity Check

Rules:

* [LookupFunctions](logical-analysis-rules/LookupFunctions.md)

Strategy: Once

### Substitution

Rules:

* CTESubstitution
* [WindowsSubstitution](logical-analysis-rules/WindowsSubstitution.md)
* EliminateUnions
* SubstituteUnresolvedOrdinals

Strategy: [fixedPoint](#fixedPoint)

### Resolution

Rules:

* ResolveTableValuedFunctions
* ResolveNamespace
* [ResolveCatalogs](logical-analysis-rules/ResolveCatalogs.md)
* ResolveInsertInto
* ResolveRelations
* ResolveTables
* ResolveReferences
* ResolveCreateNamedStruct
* ResolveDeserializer
* ResolveNewInstance
* ResolveUpCast
* ResolveGroupingAnalytics
* ResolvePivot
* ResolveOrdinalInOrderByAndGroupBy
* ResolveAggAliasInGroupBy
* ResolveMissingReferences
* ExtractGenerator
* ResolveGenerate
* ResolveFunctions
* ResolveAliases
* ResolveSubquery
* ResolveSubqueryColumnAliases
* ResolveWindowOrder
* ResolveWindowFrame
* ResolveNaturalAndUsingJoin
* ResolveOutputRelation
* ExtractWindowExpressions
* GlobalAggregates
* ResolveAggregateFunctions
* TimeWindowing
* ResolveInlineTables
* ResolveHigherOrderFunctions
* ResolveLambdaVariables
* ResolveTimeZone
* ResolveRandomSeed
* ResolveBinaryArithmetic
* [Type Coercion Rules](spark-sql-TypeCoercion.md#typeCoercionRules)
* [extendedResolutionRules](#extendedResolutionRules)

Strategy: [fixedPoint](#fixedPoint)

### Post-Hoc Resolution

Rules:

* [postHocResolutionRules](#postHocResolutionRules)

Strategy: Once

### Normalize Alter Table

Rules:

* ResolveAlterTableChanges

Strategy: Once

### Remove Unresolved Hints

Rules:

* RemoveAllHints

Strategy: Once

### Nondeterministic

Rules:

* PullOutNondeterministic

Strategy: Once

### UDF

Rules:

* [HandleNullInputsForUDF](logical-analysis-rules/HandleNullInputsForUDF.md)

Strategy: Once

### UpdateNullability

Rules:

* UpdateAttributeNullability

Strategy: Once

### Subquery

Rules:

* [UpdateOuterReferences](logical-analysis-rules/UpdateOuterReferences.md)

Strategy: Once

### Cleanup

Rules:

* [CleanupAliases](logical-analysis-rules/CleanupAliases.md)

Strategy: [fixedPoint](#fixedPoint)

## Creating Instance

`Analyzer` takes the following to be created:

* <span id="catalogManager"> [CatalogManager](connector/catalog/CatalogManager.md)
* <span id="conf"> [SQLConf](SQLConf.md)
* <span id="maxIterations"> Maximum number of iterations (of the [FixedPoint](#fixedPoint) rule batches)

!!! note
    `Analyzer` can also be created without specifying the [maxIterations](#maxIterations) argument which is then configured using [optimizerMaxIterations](spark-sql-CatalystConf.md#optimizerMaxIterations) configuration setting.

`Analyzer` is created when `SessionState` is requested for the [analyzer](SessionState.md#analyzer).

![Creating Analyzer](images/spark-sql-Analyzer.png)

## Accessing Analyzer

`Analyzer` is available as the [analyzer](SessionState.md#analyzer) property of `SessionState`.

```text
scala> :type spark
org.apache.spark.sql.SparkSession

scala> :type spark.sessionState.analyzer
org.apache.spark.sql.catalyst.analysis.Analyzer
```

You can access the analyzed logical plan of a structured query (as a <<spark-sql-Dataset.md#, Dataset>>) using [Dataset.explain](spark-sql-dataset-operators.md#explain) basic action (with `extended` flag enabled) or SQL's `EXPLAIN EXTENDED` SQL command.

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

Alternatively, you can access the analyzed logical plan using `QueryExecution` and its [analyzed](QueryExecution.md#analyzed) property  (that together with `numberedTreeString` method is a very good "debugging" tool).

```text
val analyzedPlan = inventory.queryExecution.analyzed
scala> println(analyzedPlan.numberedTreeString)
00 Project [id#0L, (id#0L + cast(5 as bigint)) AS new_column#3L]
01 +- Range (0, 5, step=1, splits=Some(8))
```

## <span id="fixedPoint"> FixedPoint

`FixedPoint` with [maxIterations](#maxIterations) for <<Hints, Hints>>, <<Substitution, Substitution>>, <<Resolution, Resolution>> and <<Cleanup, Cleanup>> batches.

Set when `Analyzer` is [created](#creating-instance) (and can be defined explicitly or through [optimizerMaxIterations](spark-sql-CatalystConf.md#optimizerMaxIterations) configuration setting).

## Logging

Enable `ALL` logging level for the respective session-specific loggers to see what happens inside `Analyzer`:

* `org.apache.spark.sql.internal.SessionState$$anon$1`

* `org.apache.spark.sql.hive.HiveSessionStateBuilder$$anon$1` for [Hive support](SparkSession.md#enableHiveSupport)

Add the following line to `conf/log4j.properties`:

```text
# with no Hive support
log4j.logger.org.apache.spark.sql.internal.SessionState$$anon$1=ALL

# with Hive support enabled
log4j.logger.org.apache.spark.sql.hive.HiveSessionStateBuilder$$anon$1=ALL
```

!!! note
    The reason for such weird-looking logger names is that `analyzer` attribute is created as an anonymous subclass of `Analyzer` class in the respective `SessionStates`.

Refer to [Logging](spark-logging.md).
