# CatalystConf

`CatalystConf` is...FIXME

NOTE: The default `CatalystConf` is [SQLConf](SQLConf.md).

[[configuration-methods]]
.CatalystConf's Internal Properties
[cols="1,1,2",options="header",width="100%"]
|===
| Name
| Initial Value
| Description

| [[caseSensitiveAnalysis]] `caseSensitiveAnalysis`
|
|

| [[cboEnabled]] `cboEnabled`
|
| Enables cost-based optimizations (CBO) for estimation of plan statistics when enabled.

Used in spark-sql-Optimizer-CostBasedJoinReorder.md[CostBasedJoinReorder] logical plan optimization and `Project`, `Filter`, `Join` and `Aggregate` logical operators.

| [[optimizerMaxIterations]] `optimizerMaxIterations`
| spark-sql-properties.md#spark.sql.optimizer.maxIterations[spark.sql.optimizer.maxIterations]
| Maximum number of iterations for [Analyzer](Analyzer.md#fixedPoint) and [Optimizer](Optimizer.md#fixedPoint).

| [[sessionLocalTimeZone]] `sessionLocalTimeZone`
|
|
|===

=== [[resolver]] `resolver` Method

`resolver` gives case-sensitive or case-insensitive `Resolvers` per <<caseSensitiveAnalysis, caseSensitiveAnalysis>> setting.

NOTE: `Resolver` is a mere function of two `String` parameters that returns `true` if both refer to the same entity (i.e. for case insensitive equality).
