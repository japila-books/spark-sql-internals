# Subexpression Elimination In Code-Generated Expression Evaluation (Common Expression Reuse)

**Subexpression Elimination** (aka **Common Expression Reuse**) is an optimization of a [logical query plan](logical-operators/LogicalPlan.md) that [eliminates expressions in code-generated (non-interpreted) expression evaluation](whole-stage-code-generation/CodegenContext.md#subexpressionElimination).

Subexpression Elimination is enabled by default. Use the internal <<spark.sql.subexpressionElimination.enabled, spark.sql.subexpressionElimination.enabled>> configuration property control whether the feature is enabled (`true`) or not (`false`).

Subexpression Elimination is used (by means of SparkPlan.md#subexpressionEliminationEnabled[subexpressionEliminationEnabled] flag of `SparkPlan`) when the following physical operators are requested to execute (i.e. moving away from queries to an RDD of internal rows to describe a distributed computation):

* [ProjectExec](physical-operators/ProjectExec.md#doExecute)

* [HashAggregateExec](physical-operators/HashAggregateExec.md#doExecute)

* [ObjectHashAggregateExec](physical-operators/ObjectHashAggregateExec.md#doExecute)

* [SortAggregateExec](physical-operators/SortAggregateExec.md#doExecute)

* [WindowExec](physical-operators/WindowExec.md#doExecute) (and creates a [lookup table for WindowExpressions and factory functions for WindowFunctionFrame](physical-operators/WindowExec.md#windowFrameExpressionFactoryPairs))

Internally, subexpression elimination happens when `CodegenContext` is requested for [subexpressionElimination](whole-stage-code-generation/CodegenContext.md#subexpressionElimination) (when `CodegenContext` is requested to <<generateExpressions, generateExpressions>> with <<spark.sql.subexpressionElimination.enabled, subexpression elimination>> enabled).

## <span id="spark.sql.subexpressionElimination.enabled"> spark.sql.subexpressionElimination.enabled Configuration Property

[spark.sql.subexpressionElimination.enabled](configuration-properties.md#spark.sql.subexpressionElimination.enabled) internal configuration property controls whether the subexpression elimination optimization is enabled or not.
