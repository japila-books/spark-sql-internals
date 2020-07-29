# ResolveCreateNamedStruct Logical Resolution Rule -- Resolving NamePlaceholders In CreateNamedStruct Expressions

`ResolveCreateNamedStruct` is a [logical resolution rule](../Analyzer.md#batches) that <<apply, replaces NamePlaceholders with Literals for the names in CreateNamedStruct expressions>> in an entire logical query plan.

`ResolveCreateNamedStruct` is part of the [Resolution](../Analyzer.md#Resolution) fixed-point batch in the standard batches of the [Analyzer](../Analyzer.md).

`ResolveCreateNamedStruct` is simply a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md), i.e. `Rule[LogicalPlan]`.

```text
scala> :type spark
org.apache.spark.sql.SparkSession

val q = spark.range(1).select(struct($"id"))
val logicalPlan = q.queryExecution.logical
scala> println(logicalPlan.numberedTreeString)
00 'Project [unresolvedalias(named_struct(NamePlaceholder, 'id), None)]
01 +- AnalysisBarrier
02       +- Range (0, 1, step=1, splits=Some(8))

// Let's resolve references first
import spark.sessionState.analyzer.ResolveReferences
val planWithRefsResolved = ResolveReferences(logicalPlan)

import org.apache.spark.sql.catalyst.analysis.ResolveCreateNamedStruct
val afterResolveCreateNamedStruct = ResolveCreateNamedStruct(planWithRefsResolved)
scala> println(afterResolveCreateNamedStruct.numberedTreeString)
00 'Project [unresolvedalias(named_struct(id, id#4L), None)]
01 +- AnalysisBarrier
02       +- Range (0, 1, step=1, splits=Some(8))
```

=== [[apply]] Executing Rule

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply` <<catalyst/QueryPlan.md#transformAllExpressions, traverses all Catalyst expressions>> (in the input <<spark-sql-LogicalPlan.md#, LogicalPlan>>) that are <<spark-sql-Expression-CreateNamedStruct.md#, CreateNamedStruct>> expressions which are not <<expressions/Expression.md#resolved, resolved>> yet and replaces `NamePlaceholders` with <<spark-sql-Expression-Literal.md#, Literal>> expressions.

In other words, `apply` finds unresolved <<spark-sql-Expression-CreateNamedStruct.md#, CreateNamedStruct>> expressions with `NamePlaceholder` expressions in the <<spark-sql-Expression-CreateNamedStruct.md#children, children>> and replaces them with the <<spark-sql-Expression-NamedExpression.md#name, name>> of corresponding <<spark-sql-Expression-NamedExpression.md#, NamedExpression>>, but only if the `NamedExpression` is resolved.

In the end, `apply` creates a <<spark-sql-Expression-CreateNamedStruct.md#creating-instance, CreateNamedStruct>> with new children.

`apply` is part of the [Rule](catalyst/Rule.md#apply) abstraction.
