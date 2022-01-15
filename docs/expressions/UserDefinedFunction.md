# UserDefinedFunction

`UserDefinedFunction` is an [abstraction](#contract) of [user-defined functions](#implementations) (UDFs).

## Contract (Subset)

### <span id="apply"> Creating Column for Execution

```scala
apply(
  exprs: Column*): Column
```

[Column](../Column.md) with [Expression](expression.md) to invoke this `UserDefinedFunction`

Used when:

* FIXME

### <span id="withName"> withName

```scala
withName(
  name: String): UserDefinedFunction
```

Used when:

* `Bucketizer` (Spark MLlib) is requested to `transform`
* `UDFRegistration` is requested to [register a named UserDefinedFunction](../UDFRegistration.md#register)

## Implementations

* `SparkUserDefinedFunction`
* [UserDefinedAggregator](UserDefinedAggregator.md)

## Demo

```scala
import org.apache.spark.sql.functions.udf
val lengthUDF = udf { s: String => s.length }
```

```text
scala> :type lengthUDF
org.apache.spark.sql.expressions.UserDefinedFunction
```

```scala
val r = lengthUDF($"name")
```

```text
scala> :type r
org.apache.spark.sql.Column
```

```scala
val namedLengthUDF = lengthUDF.withName("lengthUDF")
```

```text
scala> namedLengthUDF($"name")
res2: org.apache.spark.sql.Column = UDF:lengthUDF(name)
```

```scala
val nonNullableLengthUDF = lengthUDF.asNonNullable
assert(nonNullableLengthUDF.nullable == false)
```
