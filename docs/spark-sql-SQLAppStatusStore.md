# SQLAppStatusStore

`SQLAppStatusStore` is...FIXME

`SQLAppStatusStore` is <<creating-instance, created>> when spark-sql-SQLAppStatusListener.md#onExecutionStart[SQLAppStatusListener] or spark-sql-SQLAppStatusPlugin.md#setupUI[SQLAppStatusPlugin] create a spark-sql-webui.md[SQLTab].

=== [[creating-instance]] Creating SQLAppStatusStore Instance

`SQLAppStatusStore` takes the following when created:

* [[store]] `KVStore`
* [[listener]] Optional spark-sql-SQLAppStatusListener.md[SQLAppStatusListener]
