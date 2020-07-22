# LogicalExpressions

`LogicalExpressions` is...FIXME

## CatalystSqlParser

```scala
parser: CatalystSqlParser
```

`LogicalExpressions` creates a [CatalystSqlParser](CatalystSqlParser.md) lazily once when first requested to [parseReference](#parseReference).

## parseReference

```
parseReference(
  name: String): NamedReference
```

parseReference...FIXME

parseReference is used when:

* `Expressions` is requested to [column](Expressions.md#column)

* `FieldReference` is requested to [apply](FieldReference.md#apply)

* `DataFrameWriterV2` is requested to [partitionedBy](../new-in-300/DataFrameWriterV2.md#partitionedBy)
