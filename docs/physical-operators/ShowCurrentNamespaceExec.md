# ShowCurrentNamespaceExec Physical Command

`ShowCurrentNamespaceExec` is a [physical command](V2CommandExec.md) that represents [ShowCurrentNamespace](../logical-operators/ShowCurrentNamespace.md) logical command at execution time.

```text
scala> sql("SHOW CURRENT NAMESPACE").show(truncate = false)
+-------------+---------+
|catalog      |namespace|
+-------------+---------+
|spark_catalog|default  |
+-------------+---------+
```

## Creating Instance

`ShowCurrentNamespaceExec` takes the following to be created:

* <span id="output"> Output [attributes](../expressions/Attribute.md)
* <span id="catalogManager"> [CatalogManager](../connector/catalog/CatalogManager.md)

`ShowCurrentNamespaceExec` is created when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (and plans a [ShowCurrentNamespace](../logical-operators/ShowCurrentNamespace.md) logical command).

## <span id="run"> Executing Command

```scala
run(): Seq[InternalRow]
```

`run`...FIXME

`run` is part of the [V2CommandExec](V2CommandExec.md#run) abstraction.
