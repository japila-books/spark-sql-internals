# Table

`Table` is an [abstraction](#contract) of [logical structured data set](#implementations) of data sources:

* a directory on a file system
* a topic of Apache Kafka
* a table in a catalog
* _others_

## Contract

### capabilities

```java
Set<TableCapability> capabilities()
```

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
