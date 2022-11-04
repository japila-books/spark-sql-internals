# SQLAppStatusListener

`SQLAppStatusListener` is a `SparkListener` ([Spark Core]({{ book.spark_core }}/SparkListener/)).

## Creating Instance

`SQLAppStatusListener` takes the following to be created:

* <span id="conf"> `SparkConf` ([Spark Core]({{ book.spark_core }}/SparkConf))
* <span id="kvstore"> `ElementTrackingStore` ([Spark Core]({{ book.spark_core }}/status/ElementTrackingStore))
* <span id="live"> `live` flag

`SQLAppStatusListener` is created when:

* `SharedState` is created (and initializes a [SQLAppStatusStore](../SharedState.md#statusStore))
* `SQLHistoryServerPlugin` is requested to create `SparkListener`s
