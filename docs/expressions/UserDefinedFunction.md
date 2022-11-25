# UserDefinedFunction

`UserDefinedFunction` is an [abstraction](#contract) of [user-defined functions](#implementations) (UDFs).

## Contract (Subset)

### <span id="apply"> Creating Column for Execution

```scala
apply(
  exprs: Column*): Column
```

[Column](../Column.md) with [Expression](Expression.md) to execute this `UserDefinedFunction`

### <span id="withName"> withName

```scala
withName(
  name: String): UserDefinedFunction
```

Associates the given `name` with this `UserDefinedFunction`

Used when:

* `UDFRegistration` is requested to [register a named UserDefinedFunction](../UDFRegistration.md#register)

## Implementations

* [SparkUserDefinedFunction](SparkUserDefinedFunction.md)
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
