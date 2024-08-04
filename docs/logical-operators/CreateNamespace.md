---
title: CreateNamespace
---

# CreateNamespace Unary Logical Operator

`CreateNamespace` is a unary logical operator (`UnaryCommand`) that represents the following high-level operator in logical query plans:

* [CREATE NAMESPACE](../sql/AstBuilder.md#visitCreateNamespace) SQL command

## Creating Instance

`CreateNamespace` takes the following to be created:

* <span id="name"> Name ([LogicalPlan](LogicalPlan.md))
* <span id="ifNotExists"> `ifNotExists` flag
* <span id="properties"> Properties (`Map[String, String]`)

`CreateNamespace` is created when:

* `AstBuilder` is requested to [parse CREATE NAMESPACE command](../sql/AstBuilder.md#visitCreateNamespace)

## Resolution Rules

`CreateNamespace` is resolved using the following resolution rules:

Resolution Rule | Operator
-|-
 [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical analysis rule for the [session catalog (`spark_catalog`)](../connector/catalog/CatalogV2Util.md#isSessionCatalog) | `CreateDatabaseCommand` logical command
 [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy | [CreateNamespaceExec](../physical-operators/CreateNamespaceExec.md) physical command
