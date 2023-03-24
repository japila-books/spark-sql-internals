# AggregatePushDownUtils

## <span id="getSchemaForPushedAggregation"> getSchemaForPushedAggregation

```scala
getSchemaForPushedAggregation(
  aggregation: Aggregation,
  schema: StructType,
  partitionNames: Set[String],
  dataFilters: Seq[Expression]): Option[StructType]
```

`getSchemaForPushedAggregation`...FIXME

---

`getSchemaForPushedAggregation` is used when:

* `OrcScanBuilder` is requested to [pushAggregation](orc/OrcScanBuilder.md#pushAggregation)
* `ParquetScanBuilder` is requested to [pushAggregation](parquet/ParquetScanBuilder.md#pushAggregation)
