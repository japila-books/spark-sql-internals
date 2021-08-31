# WithCTEStrategy Execution Planning Strategy

`WithCTEStrategy` is an [execution planning strategy](SparkStrategy.md) to plan [WithCTE](../logical-operators/WithCTE.md) and [CTERelationRef](../logical-operators/CTERelationRef.md) logical operators.

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): Seq[SparkPlan]
```

`apply` plans [WithCTE](../logical-operators/WithCTE.md) and [CTERelationRef](../logical-operators/CTERelationRef.md) logical operators.

---

For a `WithCTE`, `apply` removes the `WithCTE` layer by adding the [CTERelationDef](../logical-operators/WithCTE.md#cteDefs)s to the (thread-local) collection of `CTERelationDef`s (by their IDs) and marking the [logical plan](../logical-operators/WithCTE.md#plan) to [plan later](SparkStrategy.md#planLater).

---

For a `CTERelationRef`, `apply` finds the logical plan for the [cteId](../logical-operators/CTERelationRef.md#cteId) (in the (thread-local) collection of `CTERelationDef`s) and creates a [Project](../logical-operators/Project.md) logical operator (over [Alias](../expressions/Alias.md) expressions).

In the end, `apply` creates a [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) physical operator with the `Project` (to [plan later](SparkStrategy.md#planLater)), `RoundRobinPartitioning` output partitioning and `REPARTITION_BY_COL` shuffle origin.

---

`apply` is part of the [GenericStrategy](../catalyst/GenericStrategy.md#apply) abstraction.
