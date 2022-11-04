# DataFrameWriterV2

`DataFrameWriterV2` is an API for Spark SQL developers to describe how to write a [Dataset](Dataset.md) to an external storage using the [DataSource V2](new-and-noteworthy/datasource-v2.md).

`DataFrameWriterV2` is a [CreateTableWriter](CreateTableWriter.md) (and thus a [WriteConfigMethods](WriteConfigMethods.md)).

## Demo

```text
val nums = spark.range(5)
scala> :type nums
org.apache.spark.sql.Dataset[Long]

val writerV2 = nums.writeTo("t1")
scala> :type writerV2
org.apache.spark.sql.DataFrameWriterV2[Long]
```

## Creating Instance

`DataFrameWriterV2` takes the following to be created:

* Name of the target table (_multi-part table identifier_)
* [Dataset](Dataset.md)

`DataFrameWriterV2` is created when:

* [Dataset.writeTo](Dataset.md#writeTo) operator is used

## <span id="append"> append

```scala
append(): Unit
```

`append` [loads the table](connector/catalog/CatalogV2Util.md#loadTable) from the [catalog](connector/catalog/TableCatalog.md) and identifier (based on the [table name](#table)).

When found, `append` creates an [AppendData](logical-operators/AppendData.md#byName) logical command (by name) with a [DataSourceV2Relation](logical-operators/DataSourceV2Relation.md#create) logical operator (for the catalog and the identifier).

In the end, `append` [runs the command](#runCommand) with **append** execution name.

!!! tip
    Execution is announced as a [SparkListenerSQLExecutionEnd](ui/SparkListenerSQLExecutionEnd.md).

`append` throws a `NoSuchTableException` when the table could not be found.

```text
scala> spark.range(5).writeTo("my.catalog.t1").append
org.apache.spark.sql.catalyst.analysis.NoSuchTableException: Table my.catalog.t1 not found;
  at org.apache.spark.sql.DataFrameWriterV2.append(DataFrameWriterV2.scala:162)
  ... 47 elided
```

## <span id="create"> create

```scala
create(): Unit
```

`create` is part of the [CreateTableWriter](CreateTableWriter.md#create) abstraction.

`create`...FIXME

## <span id="createOrReplace"> createOrReplace

```scala
createOrReplace(): Unit
```

`createOrReplace` is part of the [CreateTableWriter](CreateTableWriter.md#createOrReplace) abstraction.

`createOrReplace`...FIXME

## <span id="option"> option

```scala
option(
  key: String,
  value: String): DataFrameWriterV2[T]
```

`option` is part of the [WriteConfigMethods](WriteConfigMethods.md#option) abstraction.

`option`...FIXME

## <span id="options"> options

```scala
options(
  options: Map[String, String]): DataFrameWriterV2[T]
```

`options` is part of the [WriteConfigMethods](WriteConfigMethods.md#options) abstraction.

`options`...FIXME

## <span id="overwrite"> overwrite

```scala
overwrite(
  condition: Column): Unit
```

`overwrite`...FIXME

## <span id="overwritePartitions"> overwritePartitions

```scala
overwritePartitions(): Unit
```

`overwritePartitions`...FIXME

## <span id="partitionedBy"> partitionedBy

```scala
partitionedBy(
  column: Column,
  columns: Column*): CreateTableWriter[T]
```

`partitionedBy` is part of the [CreateTableWriter](CreateTableWriter.md#partitionedBy) abstraction.

`partitionedBy`...FIXME

## <span id="replace"> replace

```scala
replace(): Unit
```

`replace` is part of the [CreateTableWriter](CreateTableWriter.md#replace) abstraction.

`replace`...FIXME

## <span id="tableProperty"> tableProperty

```scala
tableProperty(
  property: String,
  value: String): CreateTableWriter[T]
```

`tableProperty` is part of the [CreateTableWriter](CreateTableWriter.md#tableProperty) abstraction.

`tableProperty`...FIXME

## <span id="using"> using

```scala
using(
  provider: String): CreateTableWriter[T]
```

`using` is part of the [CreateTableWriter](CreateTableWriter.md#using) abstraction.

`using`...FIXME

## Private Methods

### <span id="internalReplace"> internalReplace

```scala
internalReplace(
  orCreate: Boolean): Unit
```

`internalReplace`...FIXME

### <span id="runCommand"> Executing Logical Command

```scala
runCommand(
  name: String)(
  command: LogicalPlan): Unit
```

`runCommand`...FIXME
