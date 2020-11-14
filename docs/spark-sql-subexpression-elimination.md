# Subexpression Elimination In Code-Generated Expression Evaluation (Common Expression Reuse)

**Subexpression Elimination** (aka **Common Expression Reuse**) is an optimisation of a [logical query plan](logical-operators/LogicalPlan.md) that [eliminates expressions in code-generated (non-interpreted) expression evaluation](CodegenContext.md#subexpressionElimination).

Subexpression Elimination is enabled by default. Use the internal <<spark.sql.subexpressionElimination.enabled, spark.sql.subexpressionElimination.enabled>> configuration property control whether the feature is enabled (`true`) or not (`false`).

Subexpression Elimination is used (by means of SparkPlan.md#subexpressionEliminationEnabled[subexpressionEliminationEnabled] flag of `SparkPlan`) when the following physical operators are requested to execute (i.e. moving away from queries to an RDD of internal rows to describe a distributed computation):

* ProjectExec.md#doExecute[ProjectExec]

* HashAggregateExec.md#doExecute[HashAggregateExec] (and for HashAggregateExec.md#finishAggregate[finishAggregate])

* ObjectHashAggregateExec.md#doExecute[ObjectHashAggregateExec]

* SortAggregateExec.md#doExecute[SortAggregateExec]

* WindowExec.md#doExecute[WindowExec] (and creates a WindowExec.md#windowFrameExpressionFactoryPairs[lookup table for WindowExpressions and factory functions for WindowFunctionFrame])

Internally, subexpression elimination happens when `CodegenContext` is requested for [subexpressionElimination](CodegenContext.md#subexpressionElimination) (when `CodegenContext` is requested to <<generateExpressions, generateExpressions>> with <<spark.sql.subexpressionElimination.enabled, subexpression elimination>> enabled).

## <span id="spark.sql.subexpressionElimination.enabled"> spark.sql.subexpressionElimination.enabled Configuration Property

[spark.sql.subexpressionElimination.enabled](configuration-properties.md#spark.sql.subexpressionElimination.enabled) internal configuration property controls whether the subexpression elimination optimization is enabled or not.
