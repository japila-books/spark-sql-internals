# Window Aggregation

*Window Aggregation* is...FIXME

=== From Structured Query to Physical Plan

<<spark-sql-Analyzer.md#, Spark Analyzer>> uses [ExtractWindowExpressions](logical-analysis-rules/ExtractWindowExpressions.md) logical resolution rule to replace (extract) <<spark-sql-Expression-WindowExpression.md#, WindowExpression>> expressions with <<spark-sql-LogicalPlan-Window.md#, Window>> logical operators in a <<spark-sql-LogicalPlan.md#, logical query plan>>.

NOTE: Window —> (BasicOperators) —> WindowExec —> WindowExec.md#doExecute (and windowExecBufferInMemoryThreshold + windowExecBufferSpillThreshold)
