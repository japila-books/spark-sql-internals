---
hide:
  - navigation
---

# Demo: Developing CatalogPlugin

The demo shows the internals of [CatalogPlugin](../connector/catalog/CatalogPlugin.md) with support for [TableCatalog](../connector/catalog/TableCatalog.md) and [SupportsNamespaces](../connector/catalog/SupportsNamespaces.md).

## Demo CatalogPlugin

### Project Configuration

Use the following `build.sbt` for the necessary dependencies.

```scala
name := "spark-sql-demo-catalog-plugin"
organization := "pl.japila.spark.sql"

version := "0.1"

scalaVersion := "2.12.12"

libraryDependencies += "org.apache.spark" %% "spark-sql" % "3.0.1" % Provided
```

### Code

!!! tip
    Use `:paste -raw` in `spark-shell` to enter paste mode and paste the code (incl. the package declaration).

    ```text
    :paste -raw
    ```

```scala
package pl.japila.spark.sql

import org.apache.spark.sql.connector.catalog._
import org.apache.spark.sql.connector.expressions.Transform
import org.apache.spark.sql.types.StructType
import org.apache.spark.sql.util.CaseInsensitiveStringMap

import java.util.{Map => JMap}

class DemoCatalog
    extends CatalogPlugin
    with TableCatalog
    with SupportsNamespaces {

  val Success = true

  override def name(): String = DemoCatalog.NAME

  override def defaultNamespace(): Array[String] = {
    val ns = super.defaultNamespace()
    println(s"defaultNamespace = ${ns.toSeq}")
    ns
  }

  override def initialize(name: String, options: CaseInsensitiveStringMap): Unit = {
    import scala.collection.JavaConverters._
    println(s">>> initialize($name, ${options.asScala})")
  }


  override def listNamespaces(): Array[Array[String]] = {
    println(">>> listNamespaces()")
    Array.empty
  }

  override def listNamespaces(namespace: Array[String]): Array[Array[String]] = {
    println(s">>> listNamespaces($namespace)")
    Array.empty
  }

  override def loadNamespaceMetadata(namespace: Array[String]): JMap[String, String] = {
    println(s">>> loadNamespaceMetadata(${namespace.toSeq})")
    import scala.collection.JavaConverters._
    Map.empty[String, String].asJava
  }

  override def createNamespace(namespace: Array[String], metadata: JMap[String, String]): Unit = {
    import scala.collection.JavaConverters._
    println(s">>> createNamespace($namespace, ${metadata.asScala})")
  }

  override def alterNamespace(namespace: Array[String], changes: NamespaceChange*): Unit = {
    println(s">>> alterNamespace($namespace, $changes)")
  }

  override def dropNamespace(namespace: Array[String]): Boolean = {
    println(s">>> dropNamespace($namespace)")
    Success
  }

  override def listTables(namespace: Array[String]): Array[Identifier] = {
    println(s">>> listTables(${namespace.toSeq})")
    Array.empty
  }

  override def loadTable(ident: Identifier): Table = {
    println(s">>> loadTable($ident)")
    ???
  }

  override def createTable(
      ident: Identifier,
      schema: StructType,
      partitions: Array[Transform],
      properties: JMap[String, String]): Table = {
    import scala.collection.JavaConverters._
    println(s">>> createTable($ident, $schema, $partitions, ${properties.asScala})")
    ???
  }

  override def alterTable(ident: Identifier, changes: TableChange*): Table = {
    println(s">>> alterTable($ident, $changes)")
    ???
  }

  override def dropTable(ident: Identifier): Boolean = {
    println(s">>> dropTable($ident)")
    Success
  }

  override def renameTable(oldIdent: Identifier, newIdent: Identifier): Unit = {
    println(s">>> renameTable($oldIdent, $newIdent)")
  }

  override def toString = s"${this.getClass.getCanonicalName}($name)"
}

object DemoCatalog {
  val NAME = "demo"
}
```

## Configure SparkSession

Let's "install" this custom `CatalogPlugin` in the current [SparkSession](../SparkSession.md).

There are various ways to do it and `SET` SQL command is as fine as the others (for the demo at least).

```scala
sql("SET spark.sql.catalog.demo=pl.japila.spark.sql.DemoCatalog")
```

## Show Time

### Access Demo Catalog using CatalogManager

Let's use the [CatalogManager](../connector/catalog/CatalogManager.md) to access the demo catalog.

```scala
val demo = spark.sessionState.catalogManager.catalog("demo")
```

```text
scala> val demo = spark.sessionState.catalogManager.catalog("demo")
>>> initialize(demo, Map())
demo: org.apache.spark.sql.connector.catalog.CatalogPlugin = pl.japila.spark.sql.DemoCatalog(demo)
```

```scala
demo.defaultNamespace
```

```text
scala> demo.defaultNamespace
defaultNamespace = WrappedArray()
res1: Array[String] = Array()
```

### Show Tables

Let's use `SHOW TABLES` SQL command to show the tables in the demo catalog.

```scala
sql("SHOW TABLES IN demo").show(truncate = false)
```

```text
scala> sql("SHOW TABLES IN demo").show(truncate = false)
>>> initialize(demo, Map())
>>> listTables(WrappedArray())
+---------+---------+
|namespace|tableName|
+---------+---------+
+---------+---------+
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
