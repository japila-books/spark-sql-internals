title: ClearCacheCommand

# ClearCacheCommand Logical Command

`ClearCacheCommand` is a link:spark-sql-LogicalPlan-RunnableCommand.adoc[logical command] to link:spark-sql-Catalog.adoc#clearCache[remove all cached tables from the in-memory cache].

`ClearCacheCommand` corresponds to `CLEAR CACHE` SQL statement.

## clearCache Labeled Alternative

`ClearCacheCommand` is described by `clearCache` labeled alternative in `statement` expression in [SqlBase.g4](../sql/AstBuilder.md#grammar) and parsed using [SparkSqlParser](../sql/SparkSqlParser.md).
