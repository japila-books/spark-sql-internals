---
title: ClearCacheCommand
---

# ClearCacheCommand Logical Command

`ClearCacheCommand` is a [logical command](RunnableCommand.md) to [remove all cached tables from the in-memory cache](../Catalog.md#clearCache).

`ClearCacheCommand` corresponds to `CLEAR CACHE` SQL statement.

## clearCache Labeled Alternative { #clearCache }

`ClearCacheCommand` is described by `clearCache` labeled alternative in `statement` expression in [SqlBaseParser.g4](../sql/AstBuilder.md#grammar) and parsed using [SparkSqlParser](../sql/SparkSqlParser.md).
