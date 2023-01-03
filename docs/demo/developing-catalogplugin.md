---
title: Developing CatalogPlugin
hide:
  - navigation
---

# Demo: Developing CatalogPlugin

The demo shows the internals of [CatalogPlugin](../connector/catalog/CatalogPlugin.md) with support for [TableCatalog](../connector/catalog/TableCatalog.md) and [SupportsNamespaces](../connector/catalog/SupportsNamespaces.md).

## Demo CatalogPlugin

Find the sources of a demo `CatalogPlugin` in the [GitHub repo](https://github.com/jaceklaskowski/spark-examples).

## Install Demo CatalogPlugin (Spark Shell)

```console
./bin/spark-shell \
  --packages pl.japila.spark:spark-examples_2.13:1.0.0-SNAPSHOT \
  --conf spark.sql.catalog.demo=pl.japila.spark.sql.DemoCatalog \
  --conf spark.sql.catalog.demo.use-thing=true \
  --conf spark.sql.catalog.demo.delete-supported=false
```

!!! tip "SET"

    You could instead use the following at runtime:

    ```scala
    sql("SET spark.sql.catalog.demo=pl.japila.spark.sql.DemoCatalog")
    ```

## Show Time

```scala
sql("SHOW CATALOGS").show(truncate = false)
```

```text
scala> sql("SET CATALOG demo")
>>> initialize(demo, Map(use-thing -> true, delete-supported -> false))
```

```text
scala> sql("SHOW NAMESPACES IN demo_db").show(false)
defaultNamespace=<EMPTY>
>>> listNamespaces(namespace=ArraySeq(demo_db))
defaultNamespace=<EMPTY>
+---------+
|namespace|
+---------+
+---------+
```

```sql
-- FIXME Make it work
SELECT * FROM demo_db.demo_schema.demo_table LIMIT 10
```

### Access Demo Catalog using CatalogManager

Let's use the [CatalogManager](../connector/catalog/CatalogManager.md) to access the demo catalog.

```scala
val demo = spark.sessionState.catalogManager.catalog("demo")
```

```text
scala> val demo = spark.sessionState.catalogManager.catalog("demo")
>>> initialize(demo, Map())
```

```text
demo.defaultNamespace
```

### Show Tables

Let's use `SHOW TABLES` SQL command to show the tables in the demo catalog.

```text
scala> sql("SHOW TABLES IN demo").show(truncate = false)
defaultNamespace=<EMPTY>
>>> listTables(ArraySeq())
defaultNamespace=<EMPTY>
+---------+---------+-----------+
|namespace|tableName|isTemporary|
+---------+---------+-----------+
+---------+---------+-----------+
```

### Create Namespace

```scala
sql("CREATE NAMESPACE IF NOT EXISTS demo.hello").show(truncate = false)
```

```text
scala> sql("CREATE NAMESPACE IF NOT EXISTS demo.hello").show(truncate = false)
>>> loadNamespaceMetadata(WrappedArray(hello))
++
||
++
++
```

### Show Namespaces

Let's use `SHOW NAMESPACES` SQL command to show the catalogs (incl. ours).

```scala
sql("SHOW NAMESPACES IN demo").show(truncate = false)
```

```text
scala> sql("SHOW NAMESPACES IN demo").show(truncate = false)
>>> listNamespaces()
+---------+
|namespace|
+---------+
+---------+
```

### Append Data to Table

```scala
spark.range(5).writeTo("demo.t1").append
```

```text
scala> spark.range(5).writeTo("demo.t1").append
>>> loadTable(t1)
scala.NotImplementedError: an implementation is missing
  at scala.Predef$.$qmark$qmark$qmark(Predef.scala:288)
  at pl.japila.spark.sql.DemoCatalog.loadTable(<pastie>:67)
  at org.apache.spark.sql.connector.catalog.CatalogV2Util$.loadTable(CatalogV2Util.scala:283)
  at org.apache.spark.sql.DataFrameWriterV2.append(DataFrameWriterV2.scala:156)
  ... 47 elided
```

## Possible Exceptions

### Failed to get database

```text
scala> spark.range(5).writeTo("demo.t1").append
20/12/28 20:01:30 WARN ObjectStore: Failed to get database demo, returning NoSuchObjectException
org.apache.spark.sql.catalyst.analysis.NoSuchTableException: Table demo.t1 not found;
  at org.apache.spark.sql.DataFrameWriterV2.append(DataFrameWriterV2.scala:162)
  ... 47 elided
```

### Cannot find catalog plugin class

```text
scala> spark.range(5).writeTo("demo.t1").append
org.apache.spark.SparkException: Cannot find catalog plugin class for catalog 'demo': pl.japila.spark.sql.DemoCatalog
  at org.apache.spark.sql.connector.catalog.Catalogs$.load(Catalogs.scala:66)
  at org.apache.spark.sql.connector.catalog.CatalogManager.$anonfun$catalog$1(CatalogManager.scala:52)
  at scala.collection.mutable.HashMap.getOrElseUpdate(HashMap.scala:86)
  at org.apache.spark.sql.connector.catalog.CatalogManager.catalog(CatalogManager.scala:52)
  at org.apache.spark.sql.connector.catalog.LookupCatalog$CatalogAndIdentifier$.unapply(LookupCatalog.scala:128)
  at org.apache.spark.sql.DataFrameWriterV2.<init>(DataFrameWriterV2.scala:52)
  at org.apache.spark.sql.Dataset.writeTo(Dataset.scala:3359)
  ... 47 elided
```

### Cannot use catalog demo: not a TableCatalog

```text
scala> spark.range(5).writeTo("demo.t1").append
>>> initialize(demo, Map())
org.apache.spark.sql.AnalysisException: Cannot use catalog demo: not a TableCatalog;
  at org.apache.spark.sql.connector.catalog.CatalogV2Implicits$CatalogHelper.asTableCatalog(CatalogV2Implicits.scala:76)
  at org.apache.spark.sql.DataFrameWriterV2.<init>(DataFrameWriterV2.scala:53)
  at org.apache.spark.sql.Dataset.writeTo(Dataset.scala:3359)
  ... 47 elided
```

### Cannot use catalog demo: does not support namespaces

```text
scala> sql("SHOW NAMESPACES IN demo").show(false)
org.apache.spark.sql.AnalysisException: Cannot use catalog demo: does not support namespaces;
  at org.apache.spark.sql.connector.catalog.CatalogV2Implicits$CatalogHelper.asNamespaceCatalog(CatalogV2Implicits.scala:83)
  at org.apache.spark.sql.execution.datasources.v2.DataSourceV2Strategy.apply(DataSourceV2Strategy.scala:277)
```
