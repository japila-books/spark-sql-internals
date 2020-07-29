# ResolveWindowFrame Logical Resolution Rule

`ResolveWindowFrame` is a logical resolution rule that the [Logical Analyzer](../Analyzer.md) uses to <<apply, validate and resolve WindowExpression expressions>> in an entire logical query plan.

`ResolveWindowFrame` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md), i.e. `Rule[LogicalPlan]`.

`ResolveWindowFrame` is part of [Resolution](../Analyzer.md#Resolution) fixed-point batch of rules.

[[transformations]]
`ResolveWindowFrame` takes a spark-sql-LogicalPlan.md[logical plan] and does the following:

. Makes sure that the window frame of a `WindowFunction` is unspecified or matches the `SpecifiedWindowFrame` of the spark-sql-Expression-WindowSpecDefinition.md[WindowSpecDefinition] expression.
+
Reports a `AnalysisException` when the frames do not match:
+
```text
Window Frame [f] must match the required frame [frame]
```

. Copies the frame specification of `WindowFunction` to spark-sql-Expression-WindowSpecDefinition.md[WindowSpecDefinition]

. Creates a new `SpecifiedWindowFrame` for `WindowExpression` with the resolved Catalyst expression and `UnspecifiedFrame`

## Example

```text
import import org.apache.spark.sql.expressions.Window
// cume_dist requires ordered windows
val q = spark.
  range(5).
  withColumn("cume_dist", cume_dist() over Window.orderBy("id"))
import org.apache.spark.sql.catalyst.plans.logical.LogicalPlan
val planBefore: LogicalPlan = q.queryExecution.logical

// Before ResolveWindowFrame
scala> println(planBefore.numberedTreeString)
00 'Project [*, cume_dist() windowspecdefinition('id ASC NULLS FIRST, UnspecifiedFrame) AS cume_dist#39]
01 +- Range (0, 5, step=1, splits=Some(8))

import spark.sessionState.analyzer.ResolveWindowFrame
val planAfter = ResolveWindowFrame.apply(plan)

// After ResolveWindowFrame
scala> println(planAfter.numberedTreeString)
00 'Project [*, cume_dist() windowspecdefinition('id ASC NULLS FIRST, RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cume_dist#31]
01 +- Range (0, 5, step=1, splits=Some(8))
```

=== [[apply]] Applying ResolveWindowFrame to Logical Plan -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of catalyst/Rule.md#apply[Rule Contract] to apply a rule to a spark-sql-LogicalPlan.md[logical plan].

`apply`...FIXME
