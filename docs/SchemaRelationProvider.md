# SchemaRelationProvider &mdash; Relation Providers With Mandatory User-Defined Schema

`SchemaRelationProvider` is the <<contract, contract>> of <<implementations, BaseRelation providers>> that <<createRelation, require a user-defined schema while creating a relation>>.

The requirement of specifying a user-defined schema is enforced when `DataSource` is requested for a [BaseRelation](DataSource.md#resolveRelation) for a given data source format. If not specified, `DataSource` throws a `AnalysisException`:

```text
A schema needs to be specified when using [className].
```

[[contract]]
[source, scala]
----
package org.apache.spark.sql.sources

trait SchemaRelationProvider {
  def createRelation(
    sqlContext: SQLContext,
    parameters: Map[String, String],
    schema: StructType): BaseRelation
}
----

.SchemaRelationProvider Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| `createRelation`
| [[createRelation]] Creates a [BaseRelation](BaseRelation.md) for the user-defined schema

Used exclusively when `DataSource` is requested for a [BaseRelation](DataSource.md#resolveRelation) for a given data source format
|===

## Implementations

!!! note
    No known native Spark SQL implementations.

!!! tip
    [RelationProvider](RelationProvider.md) is used for data source providers with schema inference.

!!! tip
    Use both `SchemaRelationProvider` and [RelationProvider](RelationProvider.md) if a data source should support both schema inference and user-defined schemas.
