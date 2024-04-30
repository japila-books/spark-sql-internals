---
title: DropNamespace
---

# DropNamespace Unary Logical Command

`DropNamespace` is a [unary logical command](LogicalPlan.md#UnaryCommand).

`DropNamespace` is resolved to [DropNamespaceExec](../physical-operators/DropNamespaceExec.md) physical operator by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy.

??? note "spark.sql.legacy.useV1Command"
    With [spark.sql.legacy.useV1Command](../configuration-properties.md#spark.sql.legacy.useV1Command) enabled (default: `false`), `DropNamespace` is resolved to `DropDatabaseCommand` logical command by [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule.

## Creating Instance

`DropNamespace` takes the following to be created:

* <span id="namespace"> Namespace [LogicalPlan](LogicalPlan.md)
* <span id="ifExists"> `ifExists` flag
* <span id="cascade"> `cascade` flag

`DropNamespace` is created when:

* `AstBuilder` is requested to [parse DROP NAMESPACE SQL statement](../sql/AstBuilder.md#visitDropNamespace)
