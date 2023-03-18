# TransformHelper

`TransformHelper` is a Scala implicit class to extend [Seq[Transform]](#transforms) with [convertTransforms](#convertTransforms) extension method.

## Creating Instance

`TransformHelper` takes the following to be created:

* <span id="transforms"> [Transform](Transform.md)s

## <span id="convertTransforms"> convertTransforms

```scala
convertTransforms: (Seq[String], Option[BucketSpec])
```

`convertTransforms`...FIXME

---

`convertTransforms` is used when:

* [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical analysis rule is [executed](../logical-analysis-rules/ResolveSessionCatalog.md#buildCatalogTable)
* `V2SessionCatalog` is requested to [createTable](../V2SessionCatalog.md#createTable) (_deprecated_)
* `CatalogImpl` is requested to [listColumns](../CatalogImpl.md#listColumns)
