# DeleteFromTable Logical Command

`DeleteFromTable` is...FIXME

!!! note "DataSourceV2Strategy Execution Planning Strategy"
    `DeleteFromTable` commands are resolved to `DeleteFromTableExec` physical operators by [DataSourceV2Strategy](../spark-sql-SparkStrategy-DataSourceV2Strategy.md) execution planning strategy (only for `DataSourceV2ScanRelation` relations).
