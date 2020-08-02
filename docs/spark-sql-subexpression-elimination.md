title: Subexpression Elimination

# Subexpression Elimination In Code-Generated Expression Evaluation (Common Expression Reuse)

*Subexpression Elimination* (aka *Common Expression Reuse*) is an optimisation of a spark-sql-LogicalPlan.md[logical query plan] that spark-sql-CodegenContext.md#subexpressionElimination[eliminates expressions in code-generated (non-interpreted) expression evaluation].

Subexpression Elimination is enabled by default. Use the internal <<spark.sql.subexpressionElimination.enabled, spark.sql.subexpressionElimination.enabled>> configuration property control whether the feature is enabled (`true`) or not (`false`).

Subexpression Elimination is used (by means of SparkPlan.md#subexpressionEliminationEnabled[subexpressionEliminationEnabled] flag of `SparkPlan`) when the following physical operators are requested to execute (i.e. moving away from queries to an RDD of internal rows to describe a distributed computation):

* spark-sql-SparkPlan-ProjectExec.md#doExecute[ProjectExec]

* spark-sql-SparkPlan-HashAggregateExec.md#doExecute[HashAggregateExec] (and for spark-sql-SparkPlan-HashAggregateExec.md#finishAggregate[finishAggregate])

* spark-sql-SparkPlan-ObjectHashAggregateExec.md#doExecute[ObjectHashAggregateExec]

* spark-sql-SparkPlan-SortAggregateExec.md#doExecute[SortAggregateExec]

* spark-sql-SparkPlan-WindowExec.md#doExecute[WindowExec] (and creates a spark-sql-SparkPlan-WindowExec.md#windowFrameExpressionFactoryPairs[lookup table for WindowExpressions and factory functions for WindowFunctionFrame])

Internally, subexpression elimination happens when `CodegenContext` is requested for spark-sql-CodegenContext.md#subexpressionElimination[subexpressionElimination] (when `CodegenContext` is requested to <<generateExpressions, generateExpressions>> with <<spark.sql.subexpressionElimination.enabled, subexpression elimination>> enabled).

=== [[spark.sql.subexpressionElimination.enabled]] spark.sql.subexpressionElimination.enabled Configuration Property

spark-sql-properties.md#spark.sql.subexpressionElimination.enabled[spark.sql.subexpressionElimination.enabled] internal configuration property controls whether the subexpression elimination optimization is enabled or not.

Use [SQLConf.subexpressionEliminationEnabled](SQLConf.md#subexpressionEliminationEnabled) method to access the current value.

[source, scala]
----
scala> import spark.sessionState.conf
import spark.sessionState.conf

scala> conf.subexpressionEliminationEnabled
res1: Boolean = true
----
