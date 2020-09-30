# AlterTableRecoverPartitionsCommand Logical Command

`AlterTableRecoverPartitionsCommand` is a [runnable logical command](RunnableCommand.md) that represents [RepairTableStatement](RepairTableStatement.md) and [AlterTableRecoverPartitionsStatement](AlterTableRecoverPartitionsStatement.md) parsed statements.

## Creating Instance

`AlterTableRecoverPartitionsCommand` takes the following to be created:

* <span id="tableName"> `TableIdentifier`
* <span id="cmd"> Command Name (default: `ALTER TABLE RECOVER PARTITIONS`)

`AlterTableRecoverPartitionsCommand` is created when:

* [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical analysis rule is executed (and resolves [RepairTableStatement](RepairTableStatement.md) and [AlterTableRecoverPartitionsStatement](AlterTableRecoverPartitionsStatement.md) parsed statements)

* [CreateDataSourceTableAsSelectCommand](CreateDataSourceTableAsSelectCommand.md) logical command is executed (for a partitioned [HadoopFsRelation](../HadoopFsRelation.md))

* `CatalogImpl` is requested to [recoverPartitions](../CatalogImpl.md#recoverPartitions)

## <span id="run"> Executing Command

```scala
run(
  spark: SparkSession): Seq[Row]
```

`run`...FIXME

`run` is part of the [RunnableCommand](RunnableCommand.md#run) abstraction.
