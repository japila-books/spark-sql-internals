# BaseRelation &mdash; Collection of Tuples with Schema

`BaseRelation` is an [abstraction](#contract) of [relations](#implementations) that are collections of tuples (_rows_) with a known [schema](#schema).

`BaseRelation` represents an external data source with data to load datasets from or write to.

`BaseRelation` is "created" when `DataSource` is requested to [resolve a relation](DataSource.md#resolveRelation).

`BaseRelation` is then transformed into a `DataFrame` when `SparkSession` is requested to [create a DataFrame](SparkSession.md#baseRelationToDataFrame).

!!! note
    "Relation" and "table" used to be synonyms, but [Connector API](connector/index.md) in Spark 3 changed it with [Table](connector/Table.md) abstraction.

## Contract

### <span id="sqlContext"> SQLContext

```scala
sqlContext: SQLContext
```

[SQLContext](SQLContext.md)

### <span id="schema"> Schema

```scala
schema: StructType
```

[Schema](types/StructType.md) of the tuples of the relation

### <span id="sizeInBytes"> Size

```scala
sizeInBytes: Long
```

Estimated size of the relation (in bytes)

Default: [spark.sql.defaultSizeInBytes](configuration-properties.md#spark.sql.defaultSizeInBytes) configuration property

`sizeInBytes` is used when `LogicalRelation` is requested for [statistics](logical-operators/LogicalRelation.md#computeStats) (and they are not available in a [catalog](logical-operators/LogicalRelation.md#catalogTable)).

### <span id="needConversion"> Needs Conversion

```scala
needConversion: Boolean
```

Controls type conversion (whether or not JVM objects inside [Row](Row.md)s needs to be converted to Catalyst types, e.g. `java.lang.String` to `UTF8String`)

Default: `true`

!!! note
    It is recommended to leave `needConversion` enabled (as is) for custom data sources (outside Spark SQL).

Used when [DataSourceStrategy](execution-planning-strategies/DataSourceStrategy.md) execution planning strategy is executed (and [does the RDD conversion](execution-planning-strategies/DataSourceStrategy.md#toCatalystRDD) from `RDD[Row]` to `RDD[InternalRow]`).

### <span id="unhandledFilters"> Unhandled Filters

```scala
unhandledFilters(
  filters: Array[Filter]): Array[Filter]
```

[Filter](Filter.md) predicates that the relation does not support (handle) natively

Default: the input filters (as it is considered safe to double evaluate filters regardless whether they could be supported or not)

Used when [DataSourceStrategy](execution-planning-strategies/DataSourceStrategy.md) execution planning strategy is executed (and [selectFilters](execution-planning-strategies/DataSourceStrategy.md#selectFilters)).

## Implementations

* ConsoleRelation ([Spark Structured Streaming]({{ book.structured_streaming }}/datasources/console/ConsoleRelation))
* [HadoopFsRelation](datasources/HadoopFsRelation.md)
* [JDBCRelation](datasources/jdbc/JDBCRelation.md)
* [KafkaRelation](datasources/kafka/KafkaRelation.md)
* [KafkaSourceProvider](datasources/kafka/KafkaSourceProvider.md)
