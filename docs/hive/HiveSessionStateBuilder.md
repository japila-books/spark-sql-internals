# HiveSessionStateBuilder

`HiveSessionStateBuilder` is a concrete ../BaseSessionStateBuilder.md[builder] to produce a Hive-aware ../SessionState.md[SessionState] for...FIXME

`HiveSessionStateBuilder` comes with Hive-specific <<analyzer, Analyzer>>, <<planner, SparkPlanner>>, <<catalog, HiveSessionCatalog>>, <<externalCatalog, HiveExternalCatalog>> and <<resourceLoader, HiveSessionResourceLoader>>.

.HiveSessionStateBuilder's Hive-Specific Properties
image::../images/spark-sql-HiveSessionStateBuilder.png[align="center"]

`HiveSessionStateBuilder` is <<creating-instance, created>> (using <<newBuilder, newBuilder>>) when...FIXME

.HiveSessionStateBuilder and SessionState (in SparkSession)
image::../images/spark-sql-HiveSessionStateBuilder-SessionState.png[align="center"]

[[properties]]
.HiveSessionStateBuilder's Properties
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| <<analyzer-indepth, analyzer>>
a| [[analyzer]] Hive-specific [logical query plan analyzer](../Analyzer.md) with the [Hive-specific rules](#analyzer-rules).

| `catalog`
a| [[catalog]] [HiveSessionCatalog](HiveSessionCatalog.md) with the following:

* <<externalCatalog, HiveExternalCatalog>>
* ../SharedState.md#globalTempViewManager[GlobalTempViewManager] from the session-specific `SharedState`
* New HiveMetastoreCatalog.md[HiveMetastoreCatalog]
* ../BaseSessionStateBuilder.md#functionRegistry[FunctionRegistry]
* ../BaseSessionStateBuilder.md#conf[SQLConf]
* New Hadoop ../SessionState.md#newHadoopConf[Configuration]
* ../BaseSessionStateBuilder.md#sqlParser[ParserInterface]
* <<resourceLoader, HiveSessionResourceLoader>>

NOTE: If <<parentState, parentState>> is defined, the state is copied to `catalog`

Used to create <<analyzer-indepth, Hive-specific Analyzer>> and a RelationConversions.md#creating-instance[RelationConversions] logical evaluation rule (as part of <<postHocResolutionRules, Hive-Specific Analyzer's PostHoc Resolution Rules>>)

| `externalCatalog`
| [[externalCatalog]] [HiveExternalCatalog](HiveExternalCatalog.md)

| <<planner-indepth, planner>>
| [[planner]] ../spark-sql-SparkPlanner.md[SparkPlanner] with <<planner-strategies, Hive-specific strategies>>.

| `resourceLoader`
| [[resourceLoader]] `HiveSessionResourceLoader`
|===

=== [[planner-indepth]] SparkPlanner with Hive-Specific Strategies -- `planner` Property

[source, scala]
----
planner: SparkPlanner
----

NOTE: `planner` is part of ../BaseSessionStateBuilder.md#planner[BaseSessionStateBuilder Contract] to create a query planner.

`planner` is a ../spark-sql-SparkPlanner.md[SparkPlanner] with...FIXME

`planner` uses the <<planner-strategies, Hive-specific strategies>>.

[[planner-strategies]]
.Hive-Specific SparkPlanner's Hive-Specific Strategies
[cols="30m,70",options="header",width="100%"]
|===
| Strategy
| Description

| HiveTableScans.md[HiveTableScans]
| [[HiveTableScans]] Replaces HiveTableRelation.md[HiveTableRelation] logical operators with HiveTableScanExec.md[HiveTableScanExec] physical operators

| `Scripts`
| [[Scripts]]
|===

=== [[analyzer-indepth]] Logical Query Plan Analyzer with Hive-Specific Rules -- `analyzer` Property

```scala
analyzer: Analyzer
```

`analyzer` is a [Logical Analyzer](../Analyzer.md) with <<catalog, Hive-specific SessionCatalog>> (and ../BaseSessionStateBuilder.md#conf[SQLConf]).

`analyzer` uses the Hive-specific <<extendedResolutionRules, extended resolution>>, <<postHocResolutionRules, postHoc resolution>> and <<extendedCheckRules, extended check>> rules.

`analyzer` is part of the [BaseSessionStateBuilder](../BaseSessionStateBuilder.md#analyzer) abstraction.

[[extendedResolutionRules]]
.Hive-Specific Analyzer's Extended Resolution Rules (in the order of execution)
[cols="1,2",options="header",width="100%"]
|===
| Logical Rule
| Description

| [ResolveHiveSerdeTable](ResolveHiveSerdeTable.md)
| [[ResolveHiveSerdeTable]]

| [FindDataSourceTable](../logical-analysis-rules/FindDataSourceTable.md)
| [[FindDataSourceTable]]

| [ResolveSQLOnFile](../logical-analysis-rules/ResolveSQLOnFile.md)
| [[ResolveSQLOnFile]]

|===

[[postHocResolutionRules]]
.Hive-Specific Analyzer's PostHoc Resolution Rules
[cols="1,2",options="header",width="100%"]
|===
| Logical Rule
| Description

| [[DetermineTableStats]] DetermineTableStats.md[DetermineTableStats]
|

| [[RelationConversions]] RelationConversions.md[RelationConversions]
|

| [[PreprocessTableCreation]] [PreprocessTableCreation](../logical-analysis-rules/PreprocessTableCreation.md)
|

| [[PreprocessTableInsertion]] `PreprocessTableInsertion`
|

| [[DataSourceAnalysis]] .[DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md)
|

| [[HiveAnalysis]] HiveAnalysis.md[HiveAnalysis]
|
|===

[[extendedCheckRules]]
.Hive-Specific Analyzer's Extended Check Rules
[cols="1,2",options="header",width="100%"]
|===
| Logical Rule
| Description

| [[PreWriteCheck]] `PreWriteCheck`
|

| [[PreReadCheck]] `PreReadCheck`
|
|===

=== [[creating-instance]] Creating HiveSessionStateBuilder Instance

`HiveSessionStateBuilder` takes the following when created:

* [[session]] ../SparkSession.md[SparkSession]
* [[parentState]] Optional ../SessionState.md[SessionState] (default: `None`)

=== [[newBuilder]] Builder Function to Create HiveSessionStateBuilder -- `newBuilder` Method

[source, scala]
----
newBuilder: (SparkSession, Option[SessionState]) => BaseSessionStateBuilder
----

NOTE: `newBuilder` is part of ../BaseSessionStateBuilder.md#newBuilder[BaseSessionStateBuilder] contract to...FIXME.

`newBuilder`...FIXME
