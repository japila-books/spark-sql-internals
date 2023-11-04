---
title: ResolveCatalogs
---

# ResolveCatalogs Logical Resolution Rule

`ResolveCatalogs` is a logical rule (`Rule[LogicalPlan]`).

`ResolveCatalogs` is part of [Resolution](../Analyzer.md#Resolution) batch of [Logical Analyzer](../Analyzer.md).

## Creating Instance

`ResolveCatalogs` takes the following to be created:

* <span id="catalogManager"> [CatalogManager](../connector/catalog/CatalogManager.md)

`ResolveCatalogs` is created when:

* `Analyzer` is requested for [batches](../Analyzer.md#batches)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

---

`apply`...FIXME
