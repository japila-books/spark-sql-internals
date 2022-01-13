# JsonToStructs

`JsonToStructs` is a [UnaryExpression](UnaryExpression.md) with [timezone](Expression.md#TimeZoneAwareExpression) support and [CodegenFallback](Expression.md#CodegenFallback).

`JsonToStructs` is an [ExpectsInputTypes](ExpectsInputTypes.md) expression.

## Creating Instance

`JsonToStructs` takes the following to be created:

* <span id="schema"> [DataType](../types/DataType.md)
* <span id="options"> Options
* <span id="child"> Child [Expression](Expression.md)
* <span id="timeZoneId"> (optional) Time Zone ID

## <span id="from_json"> from_json Standard Function

`JsonToStructs` represents [from_json](../spark-sql-functions.md#from_json) function.

```text
import org.apache.spark.sql.functions.from_json
val jsonCol = from_json($"json", new StructType())

import org.apache.spark.sql.catalyst.expressions.JsonToStructs
val jsonExpr = jsonCol.expr.asInstanceOf[JsonToStructs]
scala> println(jsonExpr.numberedTreeString)
00 jsontostructs('json, None)
01 +- 'json
```

## <span id="FAILFAST"> FAILFAST

`JsonToStructs` uses [JacksonParser](#parser) in `FAILFAST` mode that fails early when a corrupted/malformed record is found (and hence does not support `columnNameOfCorruptRecord` JSON option).
