---
title: CollapseCodegenStages
---

# CollapseCodegenStages Physical Optimization

`CollapseCodegenStages` is a physical query optimization (aka _physical query preparation rule_ or simply _preparation rule_) that [collapses physical operators and generates a Java source code for their execution](#apply).

When [executed](#apply) (with [whole-stage code generation enabled](../whole-stage-code-generation/index.md#spark.sql.codegen.wholeStage)), `CollapseCodegenStages` [inserts WholeStageCodegenExec or InputAdapter physical operators](#insertWholeStageCodegen) to the physical plan. `CollapseCodegenStages` uses so-called **control gates** before deciding whether a [physical operator](../physical-operators/SparkPlan.md) supports the [whole-stage Java code generation](../whole-stage-code-generation/index.md) or not (and what physical operator to insert):

1. Factors in physical operators with [CodegenSupport](../physical-operators/CodegenSupport.md) only

1. Enforces the [supportCodegen](#supportCodegen) custom requirements on a physical operator, i.e.
   * [supportCodegen](../physical-operators/CodegenSupport.md#supportCodegen) flag turned on
   * No [Catalyst expressions](../expressions/Expression.md) are [CodegenFallback](../expressions/CodegenFallback.md)
   * [Output schema](../catalyst/QueryPlan.md#schema) is **neither wide nor deep** and [uses just enough fields (including nested fields)](../physical-operators/WholeStageCodegenExec.md#isTooManyFields)
   * [Children](../catalyst/TreeNode.md#children) use output schema that is also [neither wide nor deep](../physical-operators/WholeStageCodegenExec.md#isTooManyFields)

`CollapseCodegenStages` is a [Catalyst rule](../catalyst/Rule.md) for transforming [physical query plans](../physical-operators/SparkPlan.md) (`Rule[SparkPlan]`).

`CollapseCodegenStages` is part of the [preparations](../QueryExecution.md#preparations) batch of physical query plan rules and is executed when `QueryExecution` is requested for the [optimized physical query plan](../QueryExecution.md#executedPlan) (in **executedPlan** phase of a query execution).

With [spark.sql.codegen.wholeStage](../configuration-properties.md#spark.sql.codegen.wholeStage) internal configuration property enabled, `CollapseCodegenStages` [finds physical operators with CodegenSupport](#insertWholeStageCodegen) for which [whole-stage codegen requirements hold](#supportCodegen) and collapses them together as `WholeStageCodegenExec` physical operator (possibly with [InputAdapter](../physical-operators/InputAdapter.md) in-between for physical operators with no support for Java code generation).

??? note InputAdapter
    `InputAdapter` [shows itself with no star in the output](../physical-operators/InputAdapter.md#generateTreeString) of [explain](../dataset-operators.md#explain) (or [TreeNode.numberedTreeString](../catalyst/TreeNode.md#numberedTreeString)).

    ```text
    val q = spark.range(1).groupBy("id").count
    scala> q.explain
    == Physical Plan ==
    *HashAggregate(keys=[id#16L], functions=[count(1)])
    +- Exchange hashpartitioning(id#16L, 200)
       +- *HashAggregate(keys=[id#16L], functions=[partial_count(1)])
          +- *Range (0, 1, step=1, splits=8)
    ```

## Creating Instance

`CollapseCodegenStages` takes the following to be created:

* <span id="codegenStageCounter"> Codegen Stage Counter (Java's [AtomicInteger]({{ java.api }}/java/util/concurrent/atomic/AtomicInteger.html))

`CollapseCodegenStages` is created when:

* `QueryExecution` utility is used for the [preparations](../QueryExecution.md#preparations) batch
* `AdaptiveSparkPlanExec` physical operator is requested for the [postStageCreationRules](../physical-operators/AdaptiveSparkPlanExec.md#postStageCreationRules)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` starts [inserting WholeStageCodegenExec (with InputAdapter)](#insertWholeStageCodegen) in the input `plan` physical plan only when [spark.sql.codegen.wholeStage](../configuration-properties.md#spark.sql.codegen.wholeStage) configuration property.

Otherwise, `apply` does nothing at all (i.e. passes the input physical plan through unchanged).

## <span id="insertWholeStageCodegen"> Inserting WholeStageCodegenExec Physical Operators For Codegen Stages

```scala
insertWholeStageCodegen(
  plan: SparkPlan): SparkPlan
```

`insertWholeStageCodegen` branches off per [physical operator](../physical-operators/SparkPlan.md):

1. For physical operators with a single [output schema attribute](../catalyst/QueryPlan.md#output) of type `ObjectType`, `insertWholeStageCodegen` requests the operator for the [child](../catalyst/TreeNode.md#children) physical operators and tries to [insertWholeStageCodegen](#insertWholeStageCodegen) on them only.

1. For physical operators that support [Java code generation](../physical-operators/CodegenSupport.md) and meets the [additional requirements for codegen](#supportCodegen), `insertWholeStageCodegen` [insertInputAdapter](#insertInputAdapter) (with the operator), requests `WholeStageCodegenId` for the `getNextStageId` and then uses both to return a new [WholeStageCodegenExec](../physical-operators/WholeStageCodegenExec.md#creating-instance) physical operator.

1. For any other physical operators, `insertWholeStageCodegen` requests the operator for the [child](../catalyst/TreeNode.md#children) physical operators and tries to [insertWholeStageCodegen](#insertWholeStageCodegen) on them only.

`insertWholeStageCodegen` skips physical operators with a single-attribute [output schema](../catalyst/QueryPlan.md#output) with the type of the attribute being `ObjectType` type.

## <span id="insertInputAdapter"> Inserting InputAdapter Unary Physical Operator

```scala
insertInputAdapter(
  plan: SparkPlan): SparkPlan
```

`insertInputAdapter` inserts an [InputAdapter](../physical-operators/InputAdapter.md) physical operator in a physical plan.

* For [SortMergeJoinExec](../physical-operators/SortMergeJoinExec.md) (with inner and outer joins) [inserts an InputAdapter operator](#insertWholeStageCodegen) for both children physical operators individually

* For [codegen-unsupported](#supportCodegen) operators [inserts an InputAdapter operator](#insertWholeStageCodegen)

* For other operators (except `SortMergeJoinExec` operator above or for which [Java code cannot be generated](#supportCodegen)) [inserts a WholeStageCodegenExec operator](#insertWholeStageCodegen) for every child operator

!!! FIXME
    Examples for every case + screenshots from web UI

## <span id="supportCodegen"> supportCodegen

### <span id="supportCodegen-SparkPlan"> Physical Operator

```scala
supportCodegen(
  plan: SparkPlan): Boolean
```

`supportCodegen` is positive (`true`) when the input [physical operator](../physical-operators/SparkPlan.md) is as follows:

1. [CodegenSupport](../physical-operators/CodegenSupport.md) and the [supportCodegen](../physical-operators/CodegenSupport.md#supportCodegen) flag is on (it is on by default)

1. No [Catalyst expressions are CodegenFallback (except LeafExpressions)](#supportCodegen-Expression)

1. Output schema is **neither wide not deep**, i.e. [uses just enough fields (including nested fields)](../physical-operators/WholeStageCodegenExec.md#isTooManyFields)

. [Children](../catalyst/TreeNode.md#children) also have the output schema that is [neither wide nor deep](../physical-operators/WholeStageCodegenExec.md#isTooManyFields)

Otherwise, `supportCodegen` is negative (`false`).

## <span id="supportCodegen-Expression"> Expression

```scala
supportCodegen(
  e: Expression): Boolean
```

`supportCodegen` is positive (`true`) when the input [Catalyst expression](../expressions/Expression.md) is the following (in the order of verification):

1. [leaf](../expressions/Expression.md#LeafExpression)

1. non-[CodegenFallback](../expressions/Expression.md#CodegenFallback)

Otherwise, `supportCodegen` is negative (`false`).

## Demo

```text
// FIXME: DEMO
// Step 1. The top-level physical operator is CodegenSupport with supportCodegen enabled
// Step 2. The top-level operator is CodegenSupport with supportCodegen disabled
// Step 3. The top-level operator is not CodegenSupport
// Step 4. "plan.output.length == 1 && plan.output.head.dataType.isInstanceOf[ObjectType]"
```

## Demo

```text
import org.apache.spark.sql.SparkSession
val spark: SparkSession = ...
// both where and select operators support codegen
// the plan tree (with the operators and expressions) meets the requirements
// That's why the plan has WholeStageCodegenExec inserted
// That you can see as stars (*) in the output of explain
val q = Seq((1,2,3)).toDF("id", "c0", "c1").where('id === 0).select('c0)
scala> q.explain
== Physical Plan ==
*Project [_2#89 AS c0#93]
+- *Filter (_1#88 = 0)
   +- LocalTableScan [_1#88, _2#89, _3#90]

// CollapseCodegenStages is only used in QueryExecution.executedPlan
// Use sparkPlan then so we avoid CollapseCodegenStages
val plan = q.queryExecution.sparkPlan
import org.apache.spark.sql.execution.ProjectExec
val pe = plan.asInstanceOf[ProjectExec]

scala> pe.supportCodegen
res1: Boolean = true

scala> pe.schema.fields.size
res2: Int = 1

scala> pe.children.map(_.schema).map(_.size).sum
res3: Int = 3
```

```text
import org.apache.spark.sql.SparkSession
val spark: SparkSession = ...
// both where and select support codegen
// let's break the requirement of spark.sql.codegen.maxFields
val newSpark = spark.newSession()
import org.apache.spark.sql.internal.SQLConf.WHOLESTAGE_MAX_NUM_FIELDS
newSpark.sessionState.conf.setConf(WHOLESTAGE_MAX_NUM_FIELDS, 2)

scala> println(newSpark.sessionState.conf.wholeStageMaxNumFields)
2

import newSpark.implicits._
// the same query as above but created in SparkSession with WHOLESTAGE_MAX_NUM_FIELDS as 2
val q = Seq((1,2,3)).toDF("id", "c0", "c1").where('id === 0).select('c0)

// Note that there are no stars in the output of explain
// No WholeStageCodegenExec operator in the plan => whole-stage codegen disabled
scala> q.explain
== Physical Plan ==
Project [_2#122 AS c0#126]
+- Filter (_1#121 = 0)
   +- LocalTableScan [_1#121, _2#122, _3#123]
```

## Demo

```text
val q = spark.range(3).groupBy('id % 2 as "gid").count
```

```text
// Let's see where and how many "stars" does this query get
scala> q.explain
== Physical Plan ==
*(2) HashAggregate(keys=[(id#0L % 2)#9L], functions=[count(1)])
+- Exchange hashpartitioning((id#0L % 2)#9L, 200)
   +- *(1) HashAggregate(keys=[(id#0L % 2) AS (id#0L % 2)#9L], functions=[partial_count(1)])
      +- *(1) Range (0, 3, step=1, splits=8)

// There are two stage IDs: 1 and 2 (see the round brackets)
// Looks like Exchange physical operator does not support codegen
// Let's walk through the query execution phases and see it ourselves

// sparkPlan phase is just before CollapseCodegenStages physical optimization is applied
val sparkPlan = q.queryExecution.sparkPlan
scala> println(sparkPlan.numberedTreeString)
00 HashAggregate(keys=[(id#0L % 2)#12L], functions=[count(1)], output=[gid#2L, count#5L])
01 +- HashAggregate(keys=[(id#0L % 2) AS (id#0L % 2)#12L], functions=[partial_count(1)], output=[(id#0L % 2)#12L, count#11L])
02    +- Range (0, 3, step=1, splits=8)

// Compare the above with the executedPlan phase
// which happens to be after CollapseCodegenStages physical optimization
scala> println(q.queryExecution.executedPlan.numberedTreeString)
00 *(2) HashAggregate(keys=[(id#0L % 2)#12L], functions=[count(1)], output=[gid#2L, count#5L])
01 +- Exchange hashpartitioning((id#0L % 2)#12L, 200)
02    +- *(1) HashAggregate(keys=[(id#0L % 2) AS (id#0L % 2)#12L], functions=[partial_count(1)], output=[(id#0L % 2)#12L, count#11L])
03       +- *(1) Range (0, 3, step=1, splits=8)

// Let's apply the CollapseCodegenStages rule ourselves
import org.apache.spark.sql.execution.CollapseCodegenStages
val ccsRule = CollapseCodegenStages(spark.sessionState.conf)
scala> val planAfterCCS = ccsRule.apply(sparkPlan)
planAfterCCS: org.apache.spark.sql.execution.SparkPlan =
*(1) HashAggregate(keys=[(id#0L % 2)#12L], functions=[count(1)], output=[gid#2L, count#5L])
+- *(1) HashAggregate(keys=[(id#0L % 2) AS (id#0L % 2)#12L], functions=[partial_count(1)], output=[(id#0L % 2)#12L, count#11L])
   +- *(1) Range (0, 3, step=1, splits=8)

// The number of stage IDs do not match
// Looks like the above misses one or more rules
// EnsureRequirements optimization rule?
// It is indeed executed before CollapseCodegenStages
import org.apache.spark.sql.execution.exchange.EnsureRequirements
val erRule = EnsureRequirements(spark.sessionState.conf)
val planAfterER = erRule.apply(sparkPlan)
scala> println(planAfterER.numberedTreeString)
00 HashAggregate(keys=[(id#0L % 2)#12L], functions=[count(1)], output=[gid#2L, count#5L])
01 +- Exchange hashpartitioning((id#0L % 2)#12L, 200)
02    +- HashAggregate(keys=[(id#0L % 2) AS (id#0L % 2)#12L], functions=[partial_count(1)], output=[(id#0L % 2)#12L, count#11L])
03       +- Range (0, 3, step=1, splits=8)

// Time for CollapseCodegenStages
val planAfterCCS = ccsRule.apply(planAfterER)
scala> println(planAfterCCS.numberedTreeString)
00 *(2) HashAggregate(keys=[(id#0L % 2)#12L], functions=[count(1)], output=[gid#2L, count#5L])
01 +- Exchange hashpartitioning((id#0L % 2)#12L, 200)
02    +- *(1) HashAggregate(keys=[(id#0L % 2) AS (id#0L % 2)#12L], functions=[partial_count(1)], output=[(id#0L % 2)#12L, count#11L])
03       +- *(1) Range (0, 3, step=1, splits=8)

assert(planAfterCCS == q.queryExecution.executedPlan, "Plan after ER and CCS rules should match the executedPlan plan")

// Bingo!
// The result plan matches the executedPlan plan

// HashAggregateExec and Range physical operators support codegen (is a CodegenSupport)
// - HashAggregateExec disables codegen for ImperativeAggregate aggregate functions
// ShuffleExchangeExec does not support codegen (is not a CodegenSupport)

// The top-level physical operator should be WholeStageCodegenExec
import org.apache.spark.sql.execution.WholeStageCodegenExec
val wsce = planAfterCCS.asInstanceOf[WholeStageCodegenExec]

// The single child operator should be HashAggregateExec
import org.apache.spark.sql.execution.aggregate.HashAggregateExec
val hae = wsce.child.asInstanceOf[HashAggregateExec]

// Since ShuffleExchangeExec does not support codegen, the child of HashAggregateExec is InputAdapter
import org.apache.spark.sql.execution.InputAdapter
val ia = hae.child.asInstanceOf[InputAdapter]

// And it's only now when we can get at ShuffleExchangeExec
import org.apache.spark.sql.execution.exchange.ShuffleExchangeExec
val se = ia.child.asInstanceOf[ShuffleExchangeExec]
```

## Demo

```text
import org.apache.spark.sql.SparkSession
val spark: SparkSession = ...
// Just a structured query with explode Generator expression that supports codegen "partially"
// i.e. explode extends CodegenSupport but codegenSupport flag is off
val q = spark.range(2)
  .filter($"id" === 0)
  .select(explode(lit(Array(0,1,2))) as "exploded")
  .join(spark.range(2))
  .where($"exploded" === $"id")
scala> q.show
+--------+---+
|exploded| id|
+--------+---+
|       0|  0|
|       1|  1|
+--------+---+

// the final physical plan (after CollapseCodegenStages applied and the other optimization rules)
scala> q.explain
== Physical Plan ==
*BroadcastHashJoin [cast(exploded#34 as bigint)], [id#37L], Inner, BuildRight
:- *Filter isnotnull(exploded#34)
:  +- Generate explode([0,1,2]), false, false, [exploded#34]
:     +- *Project
:        +- *Filter (id#29L = 0)
:           +- *Range (0, 2, step=1, splits=8)
+- BroadcastExchange HashedRelationBroadcastMode(List(input[0, bigint, false]))
   +- *Range (0, 2, step=1, splits=8)

// Control when CollapseCodegenStages is applied to a query plan
// Take sparkPlan that is a physical plan before optimizations, incl. CollapseCodegenStages
val plan = q.queryExecution.sparkPlan

// Is wholeStageEnabled enabled?
// It is by default
scala> println(spark.sessionState.conf.wholeStageEnabled)
true

import org.apache.spark.sql.execution.CollapseCodegenStages
val ccs = CollapseCodegenStages(conf = spark.sessionState.conf)

scala> ccs.ruleName
res0: String = org.apache.spark.sql.execution.CollapseCodegenStages

// Before CollapseCodegenStages
scala> println(plan.numberedTreeString)
00 BroadcastHashJoin [cast(exploded#34 as bigint)], [id#37L], Inner, BuildRight
01 :- Filter isnotnull(exploded#34)
02 :  +- Generate explode([0,1,2]), false, false, [exploded#34]
03 :     +- Project
04 :        +- Filter (id#29L = 0)
05 :           +- Range (0, 2, step=1, splits=8)
06 +- Range (0, 2, step=1, splits=8)

// After CollapseCodegenStages
// Note the stars (that WholeStageCodegenExec.generateTreeString gives)
val execPlan = ccs.apply(plan)
scala> println(execPlan.numberedTreeString)
00 *BroadcastHashJoin [cast(exploded#34 as bigint)], [id#37L], Inner, BuildRight
01 :- *Filter isnotnull(exploded#34)
02 :  +- Generate explode([0,1,2]), false, false, [exploded#34]
03 :     +- *Project
04 :        +- *Filter (id#29L = 0)
05 :           +- *Range (0, 2, step=1, splits=8)
06 +- *Range (0, 2, step=1, splits=8)

// The first star is from WholeStageCodegenExec physical operator
import org.apache.spark.sql.execution.WholeStageCodegenExec
val wsc = execPlan(0).asInstanceOf[WholeStageCodegenExec]
scala> println(wsc.numberedTreeString)
00 *BroadcastHashJoin [cast(exploded#34 as bigint)], [id#37L], Inner, BuildRight
01 :- *Filter isnotnull(exploded#34)
02 :  +- Generate explode([0,1,2]), false, false, [exploded#34]
03 :     +- *Project
04 :        +- *Filter (id#29L = 0)
05 :           +- *Range (0, 2, step=1, splits=8)
06 +- *Range (0, 2, step=1, splits=8)

// Let's disable wholeStage codegen
// CollapseCodegenStages becomes a noop
// It is as if we were not applied Spark optimizations to a physical plan
// We're selective as we only disable whole-stage codegen
val newSpark = spark.newSession()
import org.apache.spark.sql.internal.SQLConf.WHOLESTAGE_CODEGEN_ENABLED
newSpark.sessionState.conf.setConf(WHOLESTAGE_CODEGEN_ENABLED, false)
scala> println(newSpark.sessionState.conf.wholeStageEnabled)
false

// Whole-stage codegen is disabled
// So regardless whether you do apply Spark optimizations or not
// Java code generation won't take place
val ccsWholeStageDisabled = CollapseCodegenStages(conf = newSpark.sessionState.conf)
val execPlan = ccsWholeStageDisabled.apply(plan)
// Note no stars in the output
scala> println(execPlan.numberedTreeString)
00 BroadcastHashJoin [cast(exploded#34 as bigint)], [id#37L], Inner, BuildRight
01 :- Filter isnotnull(exploded#34)
02 :  +- Generate explode([0,1,2]), false, false, [exploded#34]
03 :     +- Project
04 :        +- Filter (id#29L = 0)
05 :           +- Range (0, 2, step=1, splits=8)
06 +- Range (0, 2, step=1, splits=8)
```
