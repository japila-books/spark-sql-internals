# LogicalPlanVisitor

`LogicalPlanVisitor` is an [abstraction](#contract) of [visitors](#implementations) that can [traverse a logical query plan](#visit) to compute result of type `T` (e.g., [Statistics](Statistics.md) or unique [Expression](../expressions/Expression.md)s).

??? note "Type Constructor"
    `LogicalPlanVisitor[T]` is a Scala type constructor with the type parameter `T`.

??? note "Visitor Design Pattern"
    `LogicalPlanVisitor` uses [Visitor Design Pattern](https://en.wikipedia.org/wiki/Visitor_pattern) for traversing a logical query plan.

## Contract (Subset) { #contract }

### visitAggregate { #visitAggregate }

```scala
visitAggregate(
  p: Aggregate): T
```

Visits the given [Aggregate](../logical-operators/Aggregate.md) logical operator

See:

* [BasicStatsPlanVisitor](BasicStatsPlanVisitor.md#visitAggregate)
* [DistinctKeyVisitor](../DistinctKeyVisitor.md#visitAggregate)
* [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md#visitAggregate)

Used when:

* `LogicalPlanVisitor` is requested to [visit](#visit) a [Aggregate](../logical-operators/Aggregate.md) logical operator
* `BasicStatsPlanVisitor` is requested to [visitDistinct](BasicStatsPlanVisitor.md#visitDistinct)

### visitJoin { #visitJoin }

```scala
visitJoin(
  p: Join): T
```

Visits the given [Join](../logical-operators/Join.md) logical operator

See:

* [BasicStatsPlanVisitor](BasicStatsPlanVisitor.md#visitJoin)
* [DistinctKeyVisitor](../DistinctKeyVisitor.md#visitJoin)
* [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md#visitJoin)

Used when:

* `LogicalPlanVisitor` is requested to [visit](#visit) a [Join](../logical-operators/Join.md) logical operator

### visitOffset { #visitOffset }

```scala
visitOffset(
  p: Offset): T
```

Visits the given [Offset](../logical-operators/Offset.md) logical operator

See:

* [BasicStatsPlanVisitor](BasicStatsPlanVisitor.md#visitOffset)
* [DistinctKeyVisitor](../DistinctKeyVisitor.md#visitOffset)
* [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md#visitOffset)

Used when:

* `LogicalPlanVisitor` is requested to [visit](#visit) a [Offset](../logical-operators/Offset.md) logical operator

## Implementations

* [BasicStatsPlanVisitor](BasicStatsPlanVisitor.md)
* [DistinctKeyVisitor](../DistinctKeyVisitor.md)
* [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md)

## Visiting Logical Operator { #visit }

```scala
visit(
  p: LogicalPlan): T
```

`visit` is the entry point (a dispatcher) to hand over the task of computing the statistics of the given [logical operator](../logical-operators/LogicalPlan.md) to the [corresponding handler methods](#contract).

---

`visit` is used when:

* `LogicalPlanDistinctKeys` logical operator is requested for the [distinct keys](../logical-operators/LogicalPlanDistinctKeys.md#distinctKeys)
* `BasicStatsPlanVisitor` is requested to [fallback](BasicStatsPlanVisitor.md#fallback)
* `LogicalPlanStats` logical operator is requested for the [estimated statistics](LogicalPlanStats.md#stats)
