# BatchScanExec Physical Operator

`BatchScanExec` is a [leaf physical operator](DataSourceV2ScanExecBase.md).

## Creating Instance

`BatchScanExec` takes the following to be created:

* <span id="output"> Output schema (`Seq[AttributeReference]`)
* <span id="scan"> `Scan`

`BatchScanExec` is created when `DataSourceV2Strategy` execution planning strategy is [executed](../spark-sql-SparkStrategy-DataSourceV2Strategy.md#apply) (for physical operators with `DataSourceV2ScanRelation` relations).
