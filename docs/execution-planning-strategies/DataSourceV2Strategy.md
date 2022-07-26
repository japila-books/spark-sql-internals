# DataSourceV2Strategy Execution Planning Strategy

`DataSourceV2Strategy` is an [execution planning strategy](SparkStrategy.md).

Logical Operator | Physical Operator
-----------------|------------------
 [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) with [V1Scan](../connector/V1Scan.md) | [RowDataSourceScanExec](../physical-operators/RowDataSourceScanExec.md)
 [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) | [BatchScanExec](../physical-operators/BatchScanExec.md)
 `StreamingDataSourceV2Relation` |
 [WriteToDataSourceV2](../logical-operators/WriteToDataSourceV2.md) | [WriteToDataSourceV2Exec](../physical-operators/WriteToDataSourceV2Exec.md)
 [CreateTableAsSelect](../logical-operators/CreateTableAsSelect.md) | `AtomicCreateTableAsSelectExec` or [CreateTableAsSelectExec](../physical-operators/CreateTableAsSelectExec.md)
 `RefreshTable` | `RefreshTableExec`
 `ReplaceTable` | `AtomicReplaceTableExec` or `ReplaceTableExec`
 `ReplaceTableAsSelect` | `AtomicReplaceTableAsSelectExec` or `ReplaceTableAsSelectExec`
 [AppendData](../logical-operators/AppendData.md) | `AppendDataExecV1` or `AppendDataExec`
 [OverwriteByExpression](../logical-operators/OverwriteByExpression.md) with a [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md) | `OverwriteByExpressionExecV1` or [OverwriteByExpressionExec](../physical-operators/OverwriteByExpressionExec.md)
 [OverwritePartitionsDynamic](../logical-operators/OverwritePartitionsDynamic.md) | `OverwritePartitionsDynamicExec`
 [DeleteFromTable](../logical-operators/DeleteFromTable.md) with [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) | [DeleteFromTableExec](../physical-operators/DeleteFromTableExec.md)
 `WriteToContinuousDataSource` | `WriteToContinuousDataSourceExec`
 `DescribeNamespace` | `DescribeNamespaceExec`
 [DescribeRelation](../logical-operators/DescribeRelation.md) | [DescribeTableExec](../physical-operators/DescribeTableExec.md)
 `DropTable` | `DropTableExec`
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
