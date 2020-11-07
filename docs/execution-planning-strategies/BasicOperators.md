# BasicOperators Execution Planning Strategy

`BasicOperators` is an [execution planning strategy](SparkStrategy.md) (of [SparkPlanner](../SparkPlanner.md)) that in general does simple <<conversions, conversions>> from spark-sql-LogicalPlan.md[logical operators] to their SparkPlan.md[physical counterparts].

[[apply]]
[[conversions]]
.BasicOperators' Logical to Physical Operator Conversions
[options="header",width="100%",cols="1,1"]
|===
| Logical Operator
| Physical Operator

| [[RunnableCommand]] RunnableCommand.md[RunnableCommand]
| ExecutedCommandExec.md[ExecutedCommandExec]

| spark-sql-streaming-MemoryPlan.md[MemoryPlan]
| LocalTableScanExec.md[LocalTableScanExec]

| DeserializeToObject.md[DeserializeToObject]
| `DeserializeToObjectExec`

| `SerializeFromObject` | `SerializeFromObjectExec`
| `MapPartitions` | `MapPartitionsExec`
| `MapElements` | `MapElementsExec`
| `AppendColumns` | `AppendColumnsExec`
| `AppendColumnsWithObject` | `AppendColumnsWithObjectExec`
| `MapGroups` | `MapGroupsExec`
| `CoGroup` | `CoGroupExec`

| `Repartition` (with shuffle enabled)
| ShuffleExchangeExec.md[ShuffleExchangeExec]

| `Repartition`
| CoalesceExec.md[CoalesceExec]

| `SortPartitions` | SortExec.md[SortExec]

| [[Sort]] <<Sort.md#, Sort>>
| [[SortExec]] <<SortExec.md#, SortExec>>

| [[Project]] `Project`
| [[ProjectExec]] `ProjectExec`

| [[Filter]] `Filter`
| <<FilterExec.md#, FilterExec>>

| [[TypedFilter]] `TypedFilter`
| <<FilterExec.md#, FilterExec>>

| [[Expand]] Expand.md[Expand]
| `ExpandExec`

| [[Window]] <<Window.md#, Window>>
| [[WindowExec]] <<WindowExec.md#, WindowExec>>

| `Sample`
| `SampleExec`

| LocalRelation.md[LocalRelation]
| LocalTableScanExec.md[LocalTableScanExec]

| `LocalLimit` | `LocalLimitExec`
| [GlobalLimit](../logical-operators/GlobalLimit.md) | `GlobalLimitExec`
| `Union` | `UnionExec`

| [[Generate]] Generate.md[Generate]
| [[GenerateExec]] GenerateExec.md[GenerateExec]

| [[OneRowRelation]] `OneRowRelation`
| RDDScanExec.md[RDDScanExec]

| `Range`
| RangeExec.md[RangeExec]

| `RepartitionByExpression`
| ShuffleExchangeExec.md[ShuffleExchangeExec]

| [[ExternalRDD]] ExternalRDD.md[ExternalRDD]
| [[ExternalRDDScanExec]] ExternalRDDScanExec.md[ExternalRDDScanExec]

| [[LogicalRDD]] LogicalRDD.md[LogicalRDD]
| RDDScanExec.md[RDDScanExec]
|===

TIP: Confirm the operator mapping in the ++https://github.com/apache/spark/blob/master/sql/core/src/main/scala/org/apache/spark/sql/execution/SparkStrategies.scala#L321++[source code of `BasicOperators`].

NOTE: `BasicOperators` expects that `Distinct`, `Intersect`, and `Except` logical operators are not used in a spark-sql-LogicalPlan.md[logical plan] and throws a `IllegalStateException` if not.
