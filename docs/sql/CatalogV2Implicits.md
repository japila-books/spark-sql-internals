# CatalogV2Implicits

## CatalystSqlParser

```scala
catalystSqlParser: CatalystSqlParser
```

CatalogV2Implicits creates a [CatalystSqlParser](CatalystSqlParser.md) lazily once when first requested to [parseColumnPath](#parseColumnPath).

## parseColumnPath

```scala
parseColumnPath(
  name: String): Seq[String]
```

parseColumnPath requests the [CatalystSqlParser](#catalystSqlParser) to [parseMultipartIdentifier](CatalystSqlParser.md#parseMultipartIdentifier).

parseColumnPath is used when Filter is requested to [v2references](../Filter.md#v2references).
