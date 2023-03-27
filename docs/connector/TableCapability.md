# TableCapability

`TableCapability` represents capabilities that can be provided (_supported_) by a [Table](Table.md#capabilities).

## <span id="ACCEPT_ANY_SCHEMA"> ACCEPT_ANY_SCHEMA

Indicates that a table accepts input of any schema in a write operation

Used when:

* `DataSourceV2Relation` is requested to [skipSchemaResolution](../logical-operators/DataSourceV2Relation.md#skipSchemaResolution)
* `KafkaTable` is requested for the [capabilities](../kafka/KafkaTable.md#capabilities)
* `NoopTable` is requested for the [capabilities](../noop/NoopTable.md#capabilities)

## <span id="BATCH_READ"> BATCH_READ

## <span id="BATCH_WRITE"> BATCH_WRITE

## <span id="CONTINUOUS_READ"> CONTINUOUS_READ

## <span id="MICRO_BATCH_READ"> MICRO_BATCH_READ

Marks the table to support reads / scans in micro-batch streaming execution mode

Used when:

* `MicroBatchExecution` stream execution engine is requested for a logical query plan
* `DataStreamReader` is requested to load data

## <span id="OVERWRITE_BY_FILTER"> OVERWRITE_BY_FILTER

## <span id="OVERWRITE_DYNAMIC"> OVERWRITE_DYNAMIC

## <span id="STREAMING_WRITE"> STREAMING_WRITE

## <span id="TRUNCATE"> TRUNCATE

## <span id="V1_BATCH_WRITE"> V1_BATCH_WRITE

