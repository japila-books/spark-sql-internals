# SortAggregateExec Aggregate Physical Operator

`SortAggregateExec` is an [aggregate unary physical operator](BaseAggregateExec.md) for **sort-based aggregation**.

![SortAggregateExec in web UI (Details for Query)](../images/SortAggregateExec-webui-details-for-query.png)

## Creating Instance

`SortAggregateExec` takes the following to be created:

* <span id="requiredChildDistributionExpressions"> (optional) Required Child Distribution [Expression](../expressions/Expression.md)s
* <span id="groupingExpressions"> Grouping [NamedExpression](../expressions/NamedExpression.md)s
* <span id="aggregateExpressions"> [AggregateExpression](../expressions/AggregateExpression.md)s
* <span id="aggregateAttributes"> Aggregate [Attribute](../expressions/Attribute.md)s
* <span id="initialInputBufferOffset"> Initial Input Buffer Offset
* <span id="resultExpressions"> Result [NamedExpression](../expressions/NamedExpression.md)s
* <span id="child"> Child [Physical Operator](SparkPlan.md)

`SortAggregateExec` is created when:

* `AggUtils` utility is used to [create a physical operator for aggregation](../AggUtils.md#createAggregate)

## <span id="metrics"> Performance Metrics

Key             | Name (in web UI)
----------------|--------------------------
numOutputRows   | number of output rows

## Demo

Let's disable preference for [ObjectHashAggregateExec](ObjectHashAggregateExec.md) physical operator (using the [spark.sql.execution.useObjectHashAggregateExec](../configuration-properties.md#spark.sql.execution.useObjectHashAggregateExec) configuration property).

```text
spark.conf.set("spark.sql.execution.useObjectHashAggregateExec", false)
assert(spark.sessionState.conf.useObjectHashAggregation == false)
```

```scala
val names = Seq(
  (0, "zero"),
  (1, "one"),
  (2, "two")).toDF("num", "name")
```

Let's use [immutable](../UnsafeRow.md#isMutable) data types for `aggregateBufferAttributes` (so [HashAggregateExec](HashAggregateExec.md) physical operator will not be selected).

```text
val q = names
  .withColumn("initial", substring('name, 0, 1))
  .groupBy('initial)
  .agg(collect_set('initial))
```

```text
scala> q.explain
== Physical Plan ==
SortAggregate(key=[initial#160], functions=[collect_set(initial#160, 0, 0)])
+- *(2) Sort [initial#160 ASC NULLS FIRST], false, 0
   +- Exchange hashpartitioning(initial#160, 200), ENSURE_REQUIREMENTS, [id=#122]
      +- SortAggregate(key=[initial#160], functions=[partial_collect_set(initial#160, 0, 0)])
         +- *(1) Sort [initial#160 ASC NULLS FIRST], false, 0
            +- *(1) LocalTableScan [initial#160]
```

```scala
import q.queryExecution.optimizedPlan
import org.apache.spark.sql.catalyst.plans.logical.Aggregate
val aggLog = optimizedPlan.asInstanceOf[Aggregate]
import org.apache.spark.sql.catalyst.planning.PhysicalAggregation
import org.apache.spark.sql.catalyst.expressions.aggregate.AggregateExpression
val (_, aggregateExpressions: Seq[AggregateExpression], _, _) = PhysicalAggregation.unapply(aggLog).get
val aggregateBufferAttributes =
  aggregateExpressions.flatMap(_.aggregateFunction.aggBufferAttributes)
```

```text
import org.apache.spark.sql.execution.aggregate.HashAggregateExec
assert(HashAggregateExec.supportsAggregate(aggregateBufferAttributes) == false)
```
