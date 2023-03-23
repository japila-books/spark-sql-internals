# SupportsMetadata

`SupportsMetadata` is an [abstraction](#contract) of [file-based scan operators](#implementations) that can [report custom metadata](#getMetaData) for formatted explain (e.g., [Dataset.explain](../Dataset.md#explain) or [EXPLAIN FORMATTED](../logical-operators/ExplainCommand.md) SQL statement).

=== "Spark Shell"

    ```scala
    val query = spark.read.parquet("demo.parquet")
    query.explain(mode = "formatted")
    ```

    ```text
    == Physical Plan ==
    * ColumnarToRow (2)
    +- Scan parquet  (1)


    (1) Scan parquet
    Output [1]: [id#14L]
    Batched: true
    Location: InMemoryFileIndex [file:/Users/jacek/dev/oss/spark/demo.parquet]
    ReadSchema: struct<id:bigint>

    (2) ColumnarToRow [codegen id : 1]
    Input [1]: [id#14L]
    ```

=== "Spark SQL CLI"

    ```sql
    EXPLAIN FORMATTED
    SELECT * FROM parquet.`demo.parquet`;
    ```

    ```text
    == Physical Plan ==

    * ColumnarToRow (2)
    +- Scan parquet  (1)

    (1) Scan parquet
    Output [1]: [id#22L]
    Batched: true
    Location: InMemoryFileIndex [file:/Users/jacek/dev/oss/spark/demo.parquet]
    ReadSchema: struct<id:bigint>

    (2) ColumnarToRow [codegen id : 1]
    Input [1]: [id#22L]
    ```

## Contract

### <span id="getMetaData"> Custom Metadata

```scala
getMetaData(): Map[String, String]
```

See:

* [FileScan](../datasources/FileScan.md#getMetaData)
* [ParquetScan](../datasources/parquet/ParquetScan.md#getMetaData)

Used when:

* [DataSourceV2ScanExecBase](../physical-operators/DataSourceV2ScanExecBase.md) physical operator is executed (and [verboseStringWithOperatorId](../physical-operators/DataSourceV2ScanExecBase.md#verboseStringWithOperatorId))

## Implementations

* [FileScan](../datasources/FileScan.md)
