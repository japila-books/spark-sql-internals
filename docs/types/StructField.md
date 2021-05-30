# StructField

`StructField` is a named field of a [StructType](StructType.md).

## Creating Instance

`StructField` takes the following to be created:

* <span id="name"> Field Name
* <span id="dataType"> [DataType](DataType.md)
* <span id="nullable"> `nullable` flag (default: `true`)
* <span id="metadata"> `Metadata` (default: `Metadata.empty`)

## <span id="toDDL"> Converting to DDL Format

```scala
toDDL: String
```

`toDDL` uses the [sql](DataType.md#sql) format of the [DataType](#dataType) and the [comment](#getDDLComment) for conversion:

```text
[name] [sql][comment]
```

`toDDL` is used when:

* `StructType` is requested to [toDDL](StructType.md#toDDL)
* [ShowCreateTableCommand](../logical-operators/ShowCreateTableCommand.md), `ShowCreateTableAsSerdeCommand` logical commands are executed

`toDDL` gives a text in the format:

```text
[quoted name] [dataType][optional comment]
```

`toDDL` is used when:

* `StructType` is requested to [convert itself to DDL format](StructType.md#toDDL)
* [ShowCreateTableCommand](../logical-operators/ShowCreateTableCommand.md) logical command is executed

## <span id="getComment"> Comment

```scala
getComment(): Option[String]
```

`getComment` is the value of the `comment` key in the [Metadata](#metadata) (if defined).

## <span id="getDDLComment"> DDL Comment

```scala
getDDLComment: String
```

`getDDLComment`...FIXME

## Demo

```scala
import org.apache.spark.sql.types.{LongType, StructField}
val f = StructField(
    name = "id",
    dataType = LongType,
    nullable = false)
  .withComment("this is a comment")
```

```text
scala> println(f)
StructField(id,LongType,false)
```

```text
scala> println(f.toDDL)
`id` BIGINT COMMENT 'this is a comment'
```
