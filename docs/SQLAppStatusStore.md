# SQLAppStatusStore

`SQLAppStatusStore` is...FIXME

`SQLAppStatusStore` is <<creating-instance, created>> when [SQLAppStatusListener](SQLAppStatusListener.md#onExecutionStart) or [SQLAppStatusPlugin](SQLAppStatusPlugin.md#setupUI) create a [SQLTab](spark-sql-webui.md).

## Creating Instance

`SQLAppStatusStore` takes the following when created:

* [[store]] `KVStore`
* [[listener]] Optional [SQLAppStatusListener](SQLAppStatusListener.md)
