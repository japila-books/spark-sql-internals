# BasicOperators Execution Planning Strategy

`BasicOperators` is an [execution planning strategy](SparkStrategy.md) (of [SparkPlanner](../SparkPlanner.md)) that in general does simple <<conversions, conversions>> from spark-sql-LogicalPlan.md[logical operators] to their SparkPlan.md[physical counterparts].

[[apply]]
[[conversions]]
.BasicOperators' Logical to Physical Operator Conversions
[options="header",width="100%",cols="1,1"]
|===
| Logical Operator
| Physical Operator

| [[RunnableCommand]] spark-sql-LogicalPlan-RunnableCommand.md[RunnableCommand]
| spark-sql-SparkPlan-ExecutedCommandExec.md[ExecutedCommandExec]

| spark-sql-streaming-MemoryPlan.md[MemoryPlan]
| spark-sql-SparkPlan-LocalTableScanExec.md[LocalTableScanExec]

| spark-sql-LogicalPlan-DeserializeToObject.md[DeserializeToObject]
| `DeserializeToObjectExec`

| `SerializeFromObject` | `SerializeFromObjectExec`
| `MapPartitions` | `MapPartitionsExec`
| `MapElements` | `MapElementsExec`
| `AppendColumns` | `AppendColumnsExec`
| `AppendColumnsWithObject` | `AppendColumnsWithObjectExec`
| `MapGroups` | `MapGroupsExec`
| `CoGroup` | `CoGroupExec`

| `Repartition` (with shuffle enabled)
| spark-sql-SparkPlan-ShuffleExchangeExec.md[ShuffleExchangeExec]

| `Repartition`
| spark-sql-SparkPlan-CoalesceExec.md[CoalesceExec]

| `SortPartitions` | spark-sql-SparkPlan-SortExec.md[SortExec]

| [[Sort]] <<spark-sql-LogicalPlan-Sort.md#, Sort>>
| [[SortExec]] <<spark-sql-SparkPlan-SortExec.md#, SortExec>>

| [[Project]] `Project`
| [[ProjectExec]] `ProjectExec`

| [[Filter]] `Filter`
| <<spark-sql-SparkPlan-FilterExec.md#, FilterExec>>

| [[TypedFilter]] `TypedFilter`
| <<spark-sql-SparkPlan-FilterExec.md#, FilterExec>>

| [[Expand]] spark-sql-LogicalPlan-Expand.md[Expand]
| `ExpandExec`

| [[Window]] <<spark-sql-LogicalPlan-Window.md#, Window>>
| [[WindowExec]] <<spark-sql-SparkPlan-WindowExec.md#, WindowExec>>

| `Sample`
| `SampleExec`

| spark-sql-LogicalPlan-LocalRelation.md[LocalRelation]
| spark-sql-SparkPlan-LocalTableScanExec.md[LocalTableScanExec]

| `LocalLimit` | `LocalLimitExec`
| [GlobalLimit](../logical-operators/GlobalLimit.md) | `GlobalLimitExec`
| `Union` | `UnionExec`

| [[Generate]] spark-sql-LogicalPlan-Generate.md[Generate]
| [[GenerateExec]] spark-sql-SparkPlan-GenerateExec.md[GenerateExec]

| [[OneRowRelation]] `OneRowRelation`
| spark-sql-SparkPlan-RDDScanExec.md[RDDScanExec]

| `Range`
| spark-sql-SparkPlan-RangeExec.md[RangeExec]

| `RepartitionByExpression`
| spark-sql-SparkPlan-ShuffleExchangeExec.md[ShuffleExchangeExec]

| [[ExternalRDD]] spark-sql-LogicalPlan-ExternalRDD.md[ExternalRDD]
| [[ExternalRDDScanExec]] spark-sql-SparkPlan-ExternalRDDScanExec.md[ExternalRDDScanExec]

| [[LogicalRDD]] spark-sql-LogicalPlan-LogicalRDD.md[LogicalRDD]
| spark-sql-SparkPlan-RDDScanExec.md[RDDScanExec]
|===

TIP: Confirm the operator mapping in the ++https://github.com/apache/spark/blob/master/sql/core/src/main/scala/org/apache/spark/sql/execution/SparkStrategies.scala#L321++[source code of `BasicOperators`].

NOTE: `BasicOperators` expects that `Distinct`, `Intersect`, and `Except` logical operators are not used in a spark-sql-LogicalPlan.md[logical plan] and throws a `IllegalStateException` if not.
