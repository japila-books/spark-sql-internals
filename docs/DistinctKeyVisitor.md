# DistinctKeyVisitor

`DistinctKeyVisitor` is a [LogicalPlanVisitor](cost-based-optimization/LogicalPlanVisitor.md) (of [Expression](expressions/Expression.md)s).

`DistinctKeyVisitor` is used when a [logical operator](logical-operators/LogicalPlanDistinctKeys.md) is requested for the [distinct keys](#distinctKeys) with [spark.sql.optimizer.propagateDistinctKeys.enabled](configuration-properties.md#spark.sql.optimizer.propagateDistinctKeys.enabled) configuration property enabled.

??? note "Singleton Object"
    `DistinctKeyVisitor` is a Scala **object** which is a class that has exactly one instance. It is created lazily when it is referenced, like a lazy val.

    Learn more in [Tour of Scala](https://docs.scala-lang.org/tour/singleton-objects.html).

## visitAggregate { #visitAggregate }

??? note "LogicalPlanVisitor"

    ```scala
    visitAggregate(
      p: Aggregate): Set[ExpressionSet]
    ```

    `visitAggregate` is part of the [LogicalPlanVisitor](cost-based-optimization/LogicalPlanVisitor.md#visitAggregate) abstraction.

`visitAggregate`...FIXME

## visitJoin { #visitJoin }

??? note "LogicalPlanVisitor"

    ```scala
    visitJoin(
      p: Join): Set[ExpressionSet]
    ```

    `visitJoin` is part of the [LogicalPlanVisitor](cost-based-optimization/LogicalPlanVisitor.md#visitJoin) abstraction.

`visitJoin`...FIXME

## visitOffset { #visitOffset }

??? note "LogicalPlanVisitor"

    ```scala
    visitOffset(
      p: Offset): Set[ExpressionSet]
    ```

    `visitOffset` is part of the [LogicalPlanVisitor](cost-based-optimization/LogicalPlanVisitor.md#visitOffset) abstraction.

`visitOffset`...FIXME
