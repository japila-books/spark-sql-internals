# KafkaRecordToRowConverter

## <span id="kafkaSchema"> kafkaSchema

```scala
kafkaSchema(
  includeHeaders: Boolean): StructType
```

`kafkaSchema` is [schemaWithHeaders](#schemaWithHeaders) for the given `includeHeaders` enabled. Otherwise, `kafkaSchema` is [schemaWithoutHeaders](#schemaWithoutHeaders).

---

`kafkaSchema` is used when:

* `KafkaRelation` is requested for the [schema](KafkaRelation.md#schema)
* `KafkaScan` is requested for the [readSchema](KafkaScan.md#readSchema)
* `KafkaSource` ([Spark Structured Streaming]({{ book.structured_streaming }}/datasources/kafka/KafkaSource)) is requested for the `schema`
* `KafkaSourceProvider` is requested for the [sourceSchema](KafkaSourceProvider.md#sourceSchema)
* `KafkaTable` is requested for the [schema](KafkaTable.md#schema)
