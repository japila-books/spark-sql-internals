# DataSourceV2Strategy Execution Planning Strategy

`DataSourceV2Strategy` is an [execution planning strategy](SparkStrategy.md).

Logical Operator | Physical Operator
-----------------|------------------
 [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) with [V1Scan](../connector/V1Scan.md) | [RowDataSourceScanExec](../physical-operators/RowDataSourceScanExec.md)
 [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) | [BatchScanExec](../physical-operators/BatchScanExec.md)
 `StreamingDataSourceV2Relation` |
 [WriteToDataSourceV2](../logical-operators/WriteToDataSourceV2.md) | [WriteToDataSourceV2Exec](../physical-operators/WriteToDataSourceV2Exec.md)
 [CreateV2Table](../logical-operators/CreateV2Table.md) | [CreateTableExec](../physical-operators/CreateTableExec.md)
 [CreateTableAsSelect](../logical-operators/CreateTableAsSelect.md) | [AtomicCreateTableAsSelectExec](../physical-operators/AtomicCreateTableAsSelectExec.md) or [CreateTableAsSelectExec](../physical-operators/CreateTableAsSelectExec.md)
 `RefreshTable` | [RefreshTableExec](../physical-operators/RefreshTableExec.md)
 `ReplaceTable` | [AtomicReplaceTableExec](../physical-operators/AtomicReplaceTableExec.md) or [ReplaceTableExec](../physical-operators/ReplaceTableExec.md)
 `ReplaceTableAsSelect` | [AtomicReplaceTableAsSelectExec](../physical-operators/AtomicReplaceTableAsSelectExec.md) or [ReplaceTableAsSelectExec](../physical-operators/ReplaceTableAsSelectExec.md)
 [AppendData](../logical-operators/AppendData.md) | [AppendDataExecV1](../physical-operators/AppendDataExecV1.md) or [AppendDataExec](../physical-operators/AppendDataExec.md)
 [OverwriteByExpression](../logical-operators/OverwriteByExpression.md) with a [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md) | [OverwriteByExpressionExecV1](../physical-operators/OverwriteByExpressionExecV1.md) or [OverwriteByExpressionExec](../physical-operators/OverwriteByExpressionExec.md)
 [OverwritePartitionsDynamic](../logical-operators/OverwritePartitionsDynamic.md) | [OverwritePartitionsDynamicExec](../physical-operators/OverwritePartitionsDynamicExec.md)
 [DeleteFromTable](../logical-operators/DeleteFromTable.md) with [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) | [DeleteFromTableExec](../physical-operators/DeleteFromTableExec.md)
 `WriteToContinuousDataSource` | `WriteToContinuousDataSourceExec`
 `DescribeNamespace` | `DescribeNamespaceExec`
 [DescribeRelation](../logical-operators/DescribeRelation.md) | [DescribeTableExec](../physical-operators/DescribeTableExec.md)
 `DropTable` | [DropTableExec](../physical-operators/DropTableExec.md)
 `NoopDropTable` | [LocalTableScanExec](../physical-operators/LocalTableScanExec.md)
 [AlterTable](../logical-operators/AlterTable.md) | [AlterTableExec](../physical-operators/AlterTableExec.md)
 _others_ |

## Creating Instance

`DataSourceV2Strategy` takes the following to be created:

* <span id="session"> [SparkSession](../SparkSession.md)

`DataSourceV2Strategy` is created when:

* `SparkPlanner` is requested for the [strategies](../SparkPlanner.md#strategies)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): Seq[SparkPlan]
```

`apply` is part of [GenericStrategy](../catalyst/GenericStrategy.md#apply) abstraction.

`apply` branches off per the type of the given [logical operator](../logical-operators/LogicalPlan.md).

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.v2.DataSourceV2Strategy` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.datasources.v2.DataSourceV2Strategy=ALL
```

Refer to [Logging](../spark-logging.md).
