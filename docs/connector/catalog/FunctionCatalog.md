# FunctionCatalog

`FunctionCatalog` is an [extension](#contract) of the [CatalogPlugin](CatalogPlugin.md) abstraction for [function catalogs](#implementations).

## Contract (Subset)

### <span id="loadFunction"> Loading Function

```java
UnboundFunction loadFunction(
  Identifier ident)
```

See [V2SessionCatalog](../../V2SessionCatalog.md#loadFunction)

Used when:

* `DelegatingCatalogExtension` is requested to [loadFunction](DelegatingCatalogExtension.md#loadFunction)
* `FunctionCatalog` is requested to [functionExists](#functionExists)
* `ResolveFunctions` logical analysis rule is requested to [resolveV2Function](../../logical-analysis-rules/ResolveFunctions.md#resolveV2Function)
* `V2ExpressionUtils` is requested to `loadV2FunctionOpt`
* `CatalogV2Util` is requested to [load a function](CatalogV2Util.md#loadFunction)

## Implementations

* [CatalogExtension](CatalogExtension.md)
* `FakeV2SessionCatalog`
* [V2SessionCatalog](../../V2SessionCatalog.md)
