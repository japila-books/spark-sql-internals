---
title: PhysicalAggregation
---

# PhysicalAggregation Scala Extractor

`PhysicalAggregation` is a Scala extractor to [destructure an Aggregate logical operator](#unapply) into a four-element tuple (`ReturnType`) with the following elements:

1. [NamedExpression](../expressions/NamedExpression.md)s of the grouping keys
1. [AggregateExpression](../expressions/AggregateExpression.md)s
1. [NamedExpression](../expressions/NamedExpression.md)s of the result
1. Child [logical operator](../logical-operators/LogicalPlan.md)

```scala title="ReturnType"
(Seq[NamedExpression], Seq[AggregateExpression], Seq[NamedExpression], LogicalPlan)
```

??? note "Scala Extractor Object"
    Learn more in the [Scala extractor objects](http://docs.scala-lang.org/tutorials/tour/extractor-objects.html).

## Destructuring Aggregate Logical Operator { #unapply }

```scala
type ReturnType = 
  (Seq[NamedExpression],      // Grouping Keys
   Seq[AggregateExpression],  // Aggregate Functions
   Seq[NamedExpression],      // Result
   LogicalPlan)               // Child

unapply(
  a: Any): Option[ReturnType]
```

`unapply` destructures an [Aggregate](../logical-operators/Aggregate.md) logical operator into a four-element [ReturnType](#ReturnType) tuple.

---

`unapply` creates a [EquivalentExpressions](../subexpression-elimination/EquivalentExpressions.md) (to eliminate duplicate aggregate expressions and avoid evaluating them multiple times).

`unapply` collects [AggregateExpressions](../expressions/AggregateExpression.md#isAggregate) in the [resultExpressions](../logical-operators/Aggregate.md#resultExpressions) of the given [Aggregate](../logical-operators/Aggregate.md) logical operator.

!!! note "Some Other Magic"
    `unapply` does _some other magic_ but it does not look interesting, but the main idea should already be explained 😉

---

`unapply` is used when:

* `StatefulAggregationStrategy` ([Spark Structured Streaming]({{ book.structured_streaming }}/execution-planning-strategies/StatefulAggregationStrategy)) execution planning strategy is executed
* [Aggregation](../execution-planning-strategies/Aggregation.md) execution planning strategy is executed
