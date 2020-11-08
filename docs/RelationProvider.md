# RelationProvider &mdash; Relation Providers with Pre-Defined Schema

`RelationProvider` is an <<contract, abstraction>> of <<implementations, providers>> of <<createRelation, relational data sources with schema inference>> (aka *schema discovery*). In other words, the schema is pre-defined, and a user-specified schema is not allowed.

[[contract]]
.RelationProvider Contract
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| createRelation
a| [[createRelation]]

[source, scala]
----
createRelation(
  sqlContext: SQLContext,
  parameters: Map[String, String]): BaseRelation
----

Creates a <<spark-sql-BaseRelation.md#, BaseRelation>> for loading data from an external data source

Used exclusively when `DataSource` is requested to [resolve a data source](DataSource.md#resolveRelation) for a given data source format

|===

When [resolving a data source](DataSource.md#resolveRelation), `DataSource` makes sure that a schema is not defined or matches the [schema](spark-sql-BaseRelation.md#schema) of the data source. `DataSource` throws an `AnalysisException` for a user-specified schema that does not match the data source's schema:

```text
[className] does not allow user-specified schemas.
```

!!! tip
    [SchemaRelationProvider](spark-sql-SchemaRelationProvider.md) is used for data source providers that require a user-defined schema.

NOTE: It is a common pattern while developing a custom data source to use <<createRelation, RelationProvider.createRelation>> with [CreatableRelationProvider](CreatableRelationProvider.md) when requested for a [relation](CreatableRelationProvider.md#createRelation) (after writing out a structured query).

[[implementations]]
.RelationProviders
[cols="30,70",options="header",width="100%"]
|===
| RelationProvider
| Description

| [JdbcRelationProvider](spark-sql-JdbcRelationProvider.md)
| [[JdbcRelationProvider]] Data source provider for <<spark-sql-jdbc.md#, JDBC data source>>

| [KafkaSourceProvider](datasources/kafka/KafkaSourceProvider.md)
| [[KafkaSourceProvider]] Data source provider for [Kafka data source](datasources/kafka/index.md)

|===
