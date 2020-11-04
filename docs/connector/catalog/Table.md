# Table

`Table` is an [abstraction](#contract) of [logical structured data set](#implementations) of data sources:

* a directory or files on a file system (e.g. [FileTable](FileTable.md))
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

### partitioning

```java
Transform[] partitioning()
```

### properties

```java
Map<String, String> properties()
```

### schema

```java
StructType schema()
```

## Implementations

* [FileTable](FileTable.md)
* [KafkaTable](KafkaTable.md)
* [NoopTable](NoopTable.md)
* [StagedTable](StagedTable.md)
* [SupportsRead](SupportsRead.md)
* [SupportsWrite](SupportsWrite.md)
* [V1Table](V1Table.md)
