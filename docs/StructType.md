# StructType

`StructType` is a recursive [DataType](types/DataType.md) with [fields](#fields) and [being a collection of fields itself](#seq).

`StructType` is used to define a schema.

## Creating Instance

`StructType` takes the following to be created:

* <span id="fields"> [StructField](StructField.md)s

## <span id="seq"> Seq[StructField]

Not only does `StructType` has [fields](#fields) but is also a collection of [StructField](StructField.md)s (`Seq[StructField]`).

All things `Seq` ([Scala]({{ scala.api }}/scala/collection/Seq.html)) apply equally here.

```text
scala> schemaTyped.foreach(println)
StructField(a,IntegerType,true)
StructField(b,StringType,true)
```

## <span id="sql"> SQL Representation

`StructType` uses `STRUCT<...>` for [SQL representation](types/DataType.md#sql) (in query plans or SQL statements).

## <span id="catalogString"> Catalog Representation

`StructType` uses `struct<...>` for [catalog representation](types/DataType.md#catalogString).

## Demo

```text
// Generating a schema from a case class
// Because we're all properly lazy
case class Person(id: Long, name: String)
import org.apache.spark.sql.Encoders
val schema = Encoders.product[Person].schema
scala> println(schema.toDDL)
`id` BIGINT,`name` STRING
```

```text
scala> schemaTyped.simpleString
res0: String = struct<a:int,b:string>

scala> schemaTyped.catalogString
res1: String = struct<a:int,b:string>

scala> schemaTyped.sql
res2: String = STRUCT<`a`: INT, `b`: STRING>
```
