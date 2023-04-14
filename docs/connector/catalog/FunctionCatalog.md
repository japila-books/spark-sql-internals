# FunctionCatalog

`FunctionCatalog` is an [extension](#contract) of the [CatalogPlugin](CatalogPlugin.md) abstraction for [function catalogs](#implementations).

`FunctionCatalog` is registered using [spark.sql.catalog](index.md#spark.sql.catalog) configuration property (as are [CatalogPlugin](CatalogPlugin.md)s).

## Contract (Subset)

### Listing Functions { #listFunctions }

```java
Identifier[] listFunctions(
  String[] namespace)
```

See:

* [V2SessionCatalog](../../V2SessionCatalog.md#listFunctions)

Used when:

* `ShowFunctionsExec` is requested to `run`

### Loading Function { #loadFunction }

```java
UnboundFunction loadFunction(
  Identifier ident)
```

See:

* [V2SessionCatalog](../../V2SessionCatalog.md#loadFunction)

Used when:

* `DelegatingCatalogExtension` is requested to [loadFunction](DelegatingCatalogExtension.md#loadFunction)
* `FunctionCatalog` is requested to [functionExists](#functionExists)
* `ResolveFunctions` logical analysis rule is requested to [resolveV2Function](../../logical-analysis-rules/ResolveFunctions.md#resolveV2Function)
* `V2ExpressionUtils` is requested to `loadV2FunctionOpt`
* `CatalogV2Util` is requested to [load a function](CatalogV2Util.md#loadFunction)

## Implementations

* [CatalogExtension](CatalogExtension.md)
* `JDBCTableCatalog`
* [V2SessionCatalog](../../V2SessionCatalog.md)
