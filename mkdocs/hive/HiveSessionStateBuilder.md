# HiveSessionStateBuilder

`HiveSessionStateBuilder` is a concrete link:../spark-sql-BaseSessionStateBuilder.adoc[builder] to produce a Hive-aware link:../spark-sql-SessionState.adoc[SessionState] for...FIXME

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
a| [[analyzer]] Hive-specific link:../spark-sql-Analyzer.adoc[logical query plan analyzer] with the <<analyzer-rules, Hive-specific rules>>.

| `catalog`
a| [[catalog]] link:HiveSessionCatalog.adoc[HiveSessionCatalog] with the following:

* <<externalCatalog, HiveExternalCatalog>>
* link:../spark-sql-SharedState.adoc#globalTempViewManager[GlobalTempViewManager] from the session-specific `SharedState`
* New link:HiveMetastoreCatalog.adoc[HiveMetastoreCatalog]
* link:../spark-sql-BaseSessionStateBuilder.adoc#functionRegistry[FunctionRegistry]
* link:../spark-sql-BaseSessionStateBuilder.adoc#conf[SQLConf]
* New Hadoop link:../spark-sql-SessionState.adoc#newHadoopConf[Configuration]
* link:../spark-sql-BaseSessionStateBuilder.adoc#sqlParser[ParserInterface]
* <<resourceLoader, HiveSessionResourceLoader>>

NOTE: If <<parentState, parentState>> is defined, the state is copied to `catalog`

Used to create <<analyzer-indepth, Hive-specific Analyzer>> and a link:RelationConversions.adoc#creating-instance[RelationConversions] logical evaluation rule (as part of <<postHocResolutionRules, Hive-Specific Analyzer's PostHoc Resolution Rules>>)

| `externalCatalog`
| [[externalCatalog]] link:HiveExternalCatalog.adoc[HiveExternalCatalog]

| <<planner-indepth, planner>>
| [[planner]] link:../spark-sql-SparkPlanner.adoc[SparkPlanner] with <<planner-strategies, Hive-specific strategies>>.

| `resourceLoader`
| [[resourceLoader]] `HiveSessionResourceLoader`
|===

=== [[planner-indepth]] SparkPlanner with Hive-Specific Strategies -- `planner` Property

[source, scala]
----
planner: SparkPlanner
----

NOTE: `planner` is part of link:../spark-sql-BaseSessionStateBuilder.adoc#planner[BaseSessionStateBuilder Contract] to create a query planner.

`planner` is a link:../spark-sql-SparkPlanner.adoc[SparkPlanner] with...FIXME

`planner` uses the <<planner-strategies, Hive-specific strategies>>.

[[planner-strategies]]
.Hive-Specific SparkPlanner's Hive-Specific Strategies
[cols="30m,70",options="header",width="100%"]
|===
| Strategy
| Description

| link:HiveTableScans.adoc[HiveTableScans]
| [[HiveTableScans]] Replaces link:HiveTableRelation.adoc[HiveTableRelation] logical operators with link:HiveTableScanExec.adoc[HiveTableScanExec] physical operators

| `Scripts`
| [[Scripts]]
|===

=== [[analyzer-indepth]] Logical Query Plan Analyzer with Hive-Specific Rules -- `analyzer` Property

[source, scala]
----
analyzer: Analyzer
----

NOTE: `analyzer` is part of link:../spark-sql-BaseSessionStateBuilder.adoc#analyzer[BaseSessionStateBuilder Contract] to create a logical query plan analyzer.

`analyzer` is a link:../spark-sql-Analyzer.adoc[Analyzer] with <<catalog, Hive-specific SessionCatalog>> (and link:../spark-sql-BaseSessionStateBuilder.adoc#conf[SQLConf]).

`analyzer` uses the Hive-specific <<extendedResolutionRules, extended resolution>>, <<postHocResolutionRules, postHoc resolution>> and <<extendedCheckRules, extended check>> rules.

[[extendedResolutionRules]]
.Hive-Specific Analyzer's Extended Resolution Rules (in the order of execution)
[cols="1,2",options="header",width="100%"]
|===
| Logical Rule
| Description

| link:ResolveHiveSerdeTable.adoc[ResolveHiveSerdeTable]
| [[ResolveHiveSerdeTable]]

| link:../spark-sql-Analyzer-FindDataSourceTable.adoc[FindDataSourceTable]
| [[FindDataSourceTable]]

| link:../spark-sql-Analyzer-ResolveSQLOnFile.adoc[ResolveSQLOnFile]
| [[ResolveSQLOnFile]]

|===

[[postHocResolutionRules]]
.Hive-Specific Analyzer's PostHoc Resolution Rules
[cols="1,2",options="header",width="100%"]
|===
| Logical Rule
| Description

| [[DetermineTableStats]] link:DetermineTableStats.adoc[DetermineTableStats]
|

| [[RelationConversions]] link:RelationConversions.adoc[RelationConversions]
|

| [[PreprocessTableCreation]] <<spark-sql-Analyzer-PreprocessTableCreation.adoc#, PreprocessTableCreation>>
|

| [[PreprocessTableInsertion]] `PreprocessTableInsertion`
|

| [[DataSourceAnalysis]] link:../spark-sql-Analyzer-DataSourceAnalysis.adoc[DataSourceAnalysis]
|

| [[HiveAnalysis]] link:HiveAnalysis.adoc[HiveAnalysis]
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

* [[session]] link:../spark-sql-SparkSession.adoc[SparkSession]
* [[parentState]] Optional link:../spark-sql-SessionState.adoc[SessionState] (default: `None`)

=== [[newBuilder]] Builder Function to Create HiveSessionStateBuilder -- `newBuilder` Method

[source, scala]
----
newBuilder: (SparkSession, Option[SessionState]) => BaseSessionStateBuilder
----

NOTE: `newBuilder` is part of link:../spark-sql-BaseSessionStateBuilder.adoc#newBuilder[BaseSessionStateBuilder] contract to...FIXME.

`newBuilder`...FIXME
