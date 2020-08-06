# Catalog &mdash; Metastore Management Interface

`Catalog` is an [abstraction](#contract) of [metadata catalogs](#implementations) for managing relational entities (e.g. database(s), tables, functions, table columns and temporary views).

`Catalog` is available using [SparkSession.catalog](SparkSession.md#catalog) property.

```scala
assert(spark.isInstanceOf[org.apache.spark.sql.SparkSession])
assert(spark.catalog.isInstanceOf[org.apache.spark.sql.catalog.Catalog])
```

## Contract

### <span id="cacheTable"> cacheTable

```scala
cacheTable(
  tableName: String): Unit
cacheTable(
  tableName: String,
  storageLevel: StorageLevel): Unit
```

Caches a given table

Used for SQL's [CACHE TABLE](spark-sql-caching-and-persistence.md#cache-table) and `AlterTableRenameCommand` command.

### Others

## Implementations

* [CatalogImpl](CatalogImpl.md)
