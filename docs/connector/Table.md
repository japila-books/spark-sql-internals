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

* [FileTable](catalog/FileTable.md)
* [KafkaTable](catalog/KafkaTable.md)
* [NoopTable](catalog/NoopTable.md)
* [StagedTable](catalog/StagedTable.md)
* [SupportsRead](catalog/SupportsRead.md)
* [SupportsWrite](catalog/SupportsWrite.md)
* [V1Table](catalog/V1Table.md)
