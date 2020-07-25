# ShowCurrentNamespace Logical Command

`ShowCurrentNamespace` is a [logical command](Command.md) that represents [ShowCurrentNamespaceStatement](ShowCurrentNamespaceStatement.md) parsed statement.

## Creating Instance

`ShowCurrentNamespace` takes the following to be created:

* <span id="catalogManager"> [CatalogManager](../connector/catalog/CatalogManager.md)

`ShowCurrentNamespace` is created when `ResolveCatalogs` logical analyzer rule is executed (and resolves a [ShowCurrentNamespaceStatement](ShowCurrentNamespaceStatement.md) parsed statement).

## <span id="output"> Output Attributes

```scala
output: Seq[Attribute]
```

`output` is two [AttributeReference](../expressions/AttributeReference.md)s:

* <span id="catalog"> `catalog`
* <span id="namespace"> `namespace`

Both are of `StringType` and non-nullable.

`output` is part of the [Command](Command.md#output) abstraction.
