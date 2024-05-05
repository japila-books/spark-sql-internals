---
title: ShowTablePropertiesExec
---

# ShowTablePropertiesExec Physical Command

`ShowTablePropertiesExec` is a [physical command](V2CommandExec.md) that represents [ShowTableProperties](../logical-operators/ShowTableProperties.md) logical command at execution time (for non-[ShowTablePropertiesCommand](../logical-operators/ShowTablePropertiesCommand.md) cases).

## Creating Instance

`ShowTablePropertiesExec` takes the following to be created:

* <span id="output"> Output [Attribute](../expressions/Attribute.md)s
* <span id="catalogTable"> [Table](../connector/Table.md)
* <span id="propertyKey"> (optional) Property Key

`ShowTablePropertiesExec` is created when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (and plans a [ShowTableProperties](../logical-operators/ShowTableProperties.md) logical command)
