# ShowTableProperties Logical Command

`ShowTableProperties` is a [logical command](Command.md) that represents `SHOW TBLPROPERTIES` SQL statement.

```scala
sql("SHOW TBLPROPERTIES d1").show(truncate = false)
```

```text
+----------------------+-------+
|key                   |value  |
+----------------------+-------+
|Type                  |MANAGED|
|delta.minReaderVersion|1      |
|delta.minWriterVersion|2      |
+----------------------+-------+
```

## Creating Instance

`ShowTableProperties` takes the following to be created:

* <span id="table"> Table [LogicalPlan](LogicalPlan.md)
* <span id="propertyKey"> (optional) Property Key

`ShowTableProperties` is created when:

* `AstBuilder` is requested to [parse SHOW TBLPROPERTIES SQL statement](../sql/AstBuilder.md#visitShowTblProperties)

* [ResolveCatalogs](../logical-analysis-rules/ResolveCatalogs.md) logical analyzer rule is executed (and resolves a [ShowCurrentNamespaceStatement](ShowCurrentNamespaceStatement.md) parsed statement)

## <span id="output"> Output Attributes

```scala
output: Seq[Attribute]
```

`output` is part of the [Command](Command.md#output) abstraction.

`output` is two [AttributeReference](../expressions/AttributeReference.md)s:

* <span id="key"> `key`
* <span id="value"> `value`

Both are of `StringType` and non-nullable.

## Execution Planning

`ShowTableProperties` is resolved to [ShowTablePropertiesCommand](ShowTablePropertiesCommand.md) logical command using [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule.

`ShowTableProperties` is planned to [ShowTablePropertiesExec](../physical-operators/ShowTablePropertiesExec.md) physical command using [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy.
