# CreateV2Table Logical Command

`CreateV2Table` is a [logical command](Command.md) and a [V2CreateTablePlan](V2CreateTablePlan.md).

`CreateV2Table` is resolved to `CreateTableExec` physical command by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy.

## Creating Instance

`CreateV2Table` takes the following to be created:

* <span id="catalog"> TableCatalog
* <span id="tableName"> Table Identifier
* <span id="tableSchema"> Table [Schema](../types/StructType.md)
* <span id="partitioning"> Partitioning (`Seq[Transform]`)
* <span id="properties"> Properties (`Map[String, String]`)
* <span id="ignoreIfExists"> `ignoreIfExists` flag

`CreateV2Table` is created when:

* [ResolveCatalogs](../logical-analysis-rules/ResolveCatalogs.md) logical resolution rule is executed (and resolves a `CreateTableStatement` parsed statement)

* [ResolveSessionCatalog](../logical-analysis-rules/Resolve) logical resolution rule is executed

## <span id="withPartitioning"> withPartitioning

```scala
withPartitioning(
  rewritten: Seq[Transform]): V2CreateTablePlan
```

`withPartitioning` sets the [partitioning](#partitioning) to the given `rewritten` partitioning.

`withPartitioning` is part of the [V2CreateTablePlan](V2CreateTablePlan.md#withPartitioning) abstraction.
