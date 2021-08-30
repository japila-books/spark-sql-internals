# CTESubstitution Logical Analysis Rule

`CTESubstitution` is a [logical analysis rule](../Analyzer.md#batches) that [transforms a logical query plan](#apply) with...FIXME

`CTESubstitution` is part of the [Substitution](../Analyzer.md#Substitution) fixed-point batch in the standard batches of the [Logical Analyzer](../Analyzer.md).

`CTESubstitution` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
