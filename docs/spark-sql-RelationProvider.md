title: RelationProvider

# RelationProvider -- Relation Providers with Pre-Defined Schema

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

Creates a <<spark-sql-BaseRelation.adoc#, BaseRelation>> for loading data from an external data source

Used exclusively when `DataSource` is requested to <<spark-sql-DataSource.adoc#resolveRelation, resolve a data source>> for a given data source format

|===

When <<spark-sql-DataSource.adoc#resolveRelation, resolving a data source>>, `DataSource` makes sure that a schema is not defined or matches the <<spark-sql-BaseRelation.adoc#schema, schema>> of the data source. `DataSource` throws an `AnalysisException` for a user-specified schema that does not match the data source's schema:

```
[className] does not allow user-specified schemas.
```

TIP: Use <<spark-sql-SchemaRelationProvider.adoc#, SchemaRelationProvider>> for data source providers that require a user-defined schema.

NOTE: It is a common pattern while developing a custom data source to use <<createRelation, RelationProvider.createRelation>> with <<spark-sql-CreatableRelationProvider.adoc#, CreatableRelationProvider>> when requested for a <<spark-sql-CreatableRelationProvider.adoc#createRelation, relation>> (after writing out a structured query).

[[implementations]]
.RelationProviders
[cols="30,70",options="header",width="100%"]
|===
| RelationProvider
| Description

| <<spark-sql-JdbcRelationProvider.adoc#, JdbcRelationProvider>>
| [[JdbcRelationProvider]] Data source provider for <<spark-sql-jdbc.adoc#, JDBC data source>>

| <<spark-sql-KafkaSourceProvider.adoc#, KafkaSourceProvider>>
| [[KafkaSourceProvider]] Data source provider for <<spark-sql-kafka.adoc#, Kafka data source>>

|===
