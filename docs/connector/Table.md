# Table

`Table` is an [abstraction](#contract) of [logical structured data set](#implementations) of data sources:

* a directory or files on a file system
* a topic of Apache Kafka
* a table in a catalog
* _others_

## Contract

### capabilities

```java
Set<TableCapability> capabilities()
```

[TableCapabilities](TableCapability.md) of the table

Used when `Table` is asked whether or not it [supports a given capability](TableHelper.md#supports)

### name

```java
String name()
```

Name of the table

### partitioning

```java
Transform[] partitioning()
```

Partitions of the table (as [Transform](Transform.md)s)

Default: (empty)

Used when:

* `ResolveInsertInto` logical analysis rule is executed
* `DataFrameWriter` is requested to [insertInto](../DataFrameWriter.md#insertInto) and [save](../DataFrameWriter.md#save)
* [DescribeTableExec](../physical-operators/DescribeTableExec.md) physical operator is executed

### properties

```java
Map<String, String> properties()
```

Table properties

Default: (empty)

Used when:

* [DescribeTableExec](../physical-operators/DescribeTableExec.md) and `ShowTablePropertiesExec` physical operators are executed

### schema

```java
StructType schema()
```

[StructType](../StructType.md) of the table

Used when:

* `DataSourceV2Relation` utility is used to [create a DataSourceV2Relation logical operator](../logical-operators/DataSourceV2Relation.md#create)
* `SimpleTableProvider` is requested to [inferSchema](SimpleTableProvider.md#inferSchema)
* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed
* [DescribeTableExec](../physical-operators/DescribeTableExec.md) physical operator is executed
* `FileDataSourceV2` is requested to [inferSchema](../FileDataSourceV2.md#inferSchema)
* (Spark Structured Streaming) `TextSocketTable` is requested for a `ScanBuilder` with a read schema
* (Spark Structured Streaming) `DataStreamReader` is requested to load data

## Implementations

* ConsoleTable (Spark Structured Streaming)
* [FileTable](FileTable.md)
* ForeachWriterTable (Spark Structured Streaming)
* [KafkaTable](../datasources/kafka/KafkaTable.md)
* MemorySink (Spark Structured Streaming)
* MemoryStreamTable (Spark Structured Streaming)
* [NoopTable](NoopTable.md)
* RateStreamTable (Spark Structured Streaming)
* Sink (Spark Structured Streaming)
* [StagedTable](StagedTable.md)
* [SupportsRead](SupportsRead.md)
* [SupportsWrite](SupportsWrite.md)
* TextSocketTable (Spark Structured Streaming)
* [V1Table](V1Table.md)
