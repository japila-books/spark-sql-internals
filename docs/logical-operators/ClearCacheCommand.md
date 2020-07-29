title: ClearCacheCommand

# ClearCacheCommand Logical Command

`ClearCacheCommand` is a spark-sql-LogicalPlan-RunnableCommand.md[logical command] to spark-sql-Catalog.md#clearCache[remove all cached tables from the in-memory cache].

`ClearCacheCommand` corresponds to `CLEAR CACHE` SQL statement.

## clearCache Labeled Alternative

`ClearCacheCommand` is described by `clearCache` labeled alternative in `statement` expression in [SqlBase.g4](../sql/AstBuilder.md#grammar) and parsed using [SparkSqlParser](../sql/SparkSqlParser.md).
