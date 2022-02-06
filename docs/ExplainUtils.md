# ExplainUtils

`ExplainUtils` is a utility to [process a query plan](#processPlan) (when `QueryExecution` is requested for a [simple (basic) text representation](QueryExecution.md#simpleString) for `formatted` explain mode).

## Demo

```scala
val q = spark.range(5).join(spark.range(10), Seq("id"), "inner")
```

```text
scala> q.explain(mode = "formatted")
== Physical Plan ==
AdaptiveSparkPlan (6)
+- Project (5)
   +- BroadcastHashJoin Inner BuildLeft (4)
      :- BroadcastExchange (2)
      :  +- Range (1)
      +- Range (3)


(1) Range
Output [1]: [id#0L]
Arguments: Range (0, 5, step=1, splits=Some(16))

(2) BroadcastExchange
Input [1]: [id#0L]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, false]),false), [id=#16]

(3) Range
Output [1]: [id#2L]
Arguments: Range (0, 10, step=1, splits=Some(16))

(4) BroadcastHashJoin
Left keys [1]: [id#0L]
Right keys [1]: [id#2L]
Join condition: None

(5) Project
Output [1]: [id#0L]
Input [2]: [id#0L, id#2L]

(6) AdaptiveSparkPlan
Output [1]: [id#0L]
Arguments: isFinalPlan=false
```

Note that the [AdaptiveSparkPlan](physical-operators/AdaptiveSparkPlanExec.md) physical operator has [isFinalPlan](physical-operators/AdaptiveSparkPlanExec.md#isFinalPlan) flag `false` (and you can see part of the final output).

Execute [Adaptive Query Execution](adaptive-query-execution/index.md) optimization.

```scala
q.take(0)
```

The [isFinalPlan](physical-operators/AdaptiveSparkPlanExec.md#isFinalPlan) flag should now be `true`.

```text
scala> q.explain(mode = "formatted")
== Physical Plan ==
AdaptiveSparkPlan (10)
+- == Final Plan ==
   * Project (6)
   +- * BroadcastHashJoin Inner BuildLeft (5)
      :- BroadcastQueryStage (3)
      :  +- BroadcastExchange (2)
      :     +- * Range (1)
      +- * Range (4)
+- == Initial Plan ==
   Project (9)
   +- BroadcastHashJoin Inner BuildLeft (8)
      :- BroadcastExchange (7)
      :  +- Range (1)
      +- Range (4)


(1) Range [codegen id : 1]
Output [1]: [id#0L]
Arguments: Range (0, 5, step=1, splits=Some(16))

(2) BroadcastExchange
Input [1]: [id#0L]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, false]),false), [id=#72]

(3) BroadcastQueryStage
Output [1]: [id#0L]
Arguments: 0

(4) Range
Output [1]: [id#2L]
Arguments: Range (0, 10, step=1, splits=Some(16))

(5) BroadcastHashJoin [codegen id : 2]
Left keys [1]: [id#0L]
Right keys [1]: [id#2L]
Join condition: None

(6) Project [codegen id : 2]
Output [1]: [id#0L]
Input [2]: [id#0L, id#2L]

(7) BroadcastExchange
Input [1]: [id#0L]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, false]),false), [id=#16]

(8) BroadcastHashJoin
Left keys [1]: [id#0L]
Right keys [1]: [id#2L]
Join condition: None

(9) Project
Output [1]: [id#0L]
Input [2]: [id#0L, id#2L]

(10) AdaptiveSparkPlan
Output [1]: [id#0L]
Arguments: isFinalPlan=true
```

## <span id="processPlan"> Processing Query Plan

```scala
processPlan[T <: QueryPlan[T]](
  plan: T,
  append: String => Unit): Unit
```

`processPlan`...FIXME

`processPlan` is used when:

* `QueryExecution` is requested to [simpleString](QueryExecution.md#simpleString)

### <span id="processPlanSkippingSubqueries"> processPlanSkippingSubqueries

```scala
processPlanSkippingSubqueries[T <: QueryPlan[T]](
  plan: T,
  append: String => Unit,
  collectedOperators: BitSet): Unit
```

`processPlanSkippingSubqueries`...FIXME

### <span id="collectOperatorsWithID"> collectOperatorsWithID

```scala
collectOperatorsWithID(
  plan: QueryPlan[_],
  operators: ArrayBuffer[QueryPlan[_]],
  collectedOperators: BitSet): Unit
```

`collectOperatorsWithID`...FIXME

### <span id="removeTags"> removeTags

```scala
removeTags(
  plan: QueryPlan[_]): Unit
```

`removeTags`...FIXME

### <span id="generateOperatorIDs"> generateOperatorIDs

```scala
generateOperatorIDs(
  plan: QueryPlan[_],
  startOperatorID: Int): Int
```

`generateOperatorIDs`...FIXME
