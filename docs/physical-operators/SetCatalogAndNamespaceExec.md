# SetCatalogAndNamespaceExec Physical Command

`SetCatalogAndNamespaceExec` is a [physical command](V2CommandExec.md) that represents [SetCatalogAndNamespace](../logical-operators/SetCatalogAndNamespace.md) logical command at execution time.

```text
val ns = "my_space"
sql(s"CREATE NAMESPACE IF NOT EXISTS $ns")

sql(s"USE NAMESPACE $ns")

sql("SHOW CURRENT NAMESPACE").show(truncate = false)
// +-------------+---------+
// |catalog      |namespace|
// +-------------+---------+
// |spark_catalog|my_space |
// +-------------+---------+
```

## Creating Instance

`SetCatalogAndNamespaceExec` takes the following to be created:

* <span id="catalogManager"> [CatalogManager](../connector/catalog/CatalogManager.md)
* <span id="catalogName"> Optional Catalog Name
* <span id="namespace"> Optional Namespace

`SetCatalogAndNamespaceExec` is created when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (and plans a [SetCatalogAndNamespace](../logical-operators/SetCatalogAndNamespace.md) logical command).
