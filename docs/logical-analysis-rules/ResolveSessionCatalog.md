# ResolveSessionCatalog Logical Extended Resolution Rule

`ResolveSessionCatalog` is a logical resolution rule (`Rule[LogicalPlan]`).

## Creating Instance

`ResolveSessionCatalog` takes the following to be created:

* <span id="catalogManager"> [CatalogManager](../connector/catalog/CatalogManager.md)
* <span id="conf"> [SQLConf](../SQLConf.md)
* <span id="isTempView"> `isTempView` Function (`Seq[String] => Boolean`)
* <span id="isTempFunction"> `isTempFunction` Function (`String => Boolean`)

`ResolveSessionCatalog` is created as an extended resolution rule when [HiveSessionStateBuilder](../hive/HiveSessionStateBuilder.md#analyzer) and [BaseSessionStateBuilder](../BaseSessionStateBuilder.md#analyzer) are requested for the analyzer.

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply`...FIXME

`apply` is part of the [Catalyst Rule](../catalyst/Rule.md#apply) abstraction.
