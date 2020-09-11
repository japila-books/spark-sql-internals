# InputPartition

`InputPartition` is an [abstraction](#contract) of [input partitions](#implementations) in [DataSource V2](../new-and-noteworthy/datasource-v2.md) with optional [location preferences](#preferredLocations).

`InputPartition` is a Java [Serializable](https://docs.oracle.com/javase/8/docs/api/java/io/Serializable.html).

## Contract

### <span id="preferredLocations"> preferredLocations

```java
String[] preferredLocations()
```

Specifies **preferred locations** (executor hosts)

By default, `preferredLocations` defines no location preferences (is simply empty).

Used when:

* `FileScanRDD` is requested for [preferred locations](../rdds/FileScanRDD.md#getPreferredLocations)

* `DataSourceRDD` is requested for [preferred locations](../DataSourceRDD.md#getPreferredLocations)

* `ContinuousDataSourceRDD` (Spark Structured Streaming) is requested for preferred locations

## Implementations

* `ContinuousMemoryStreamInputPartition`
* `FilePartition`
* `KafkaBatchInputPartition`
* `KafkaContinuousInputPartition`
* `MemoryStreamInputPartition`
* `RateStreamContinuousInputPartition`
* `RateStreamMicroBatchInputPartition`
* `TextSocketContinuousInputPartition`
* `TextSocketInputPartition`
