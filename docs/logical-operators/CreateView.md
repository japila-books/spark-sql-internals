---
title: CreateView
---

# CreateView Logical Operator

`CreateView` is a `BinaryCommand` logical operator that represents [CREATE VIEW AS](../sql/SparkSqlAstBuilder.md#visitCreateView) SQL statement to create a persisted (non-temporary) view.

??? note "CreateViewCommand"
    [CreateViewCommand](CreateViewCommand.md) logical operator is used to represent [CREATE TEMPORARY VIEW AS](../sql/SparkSqlAstBuilder.md#visitCreateView) SQL statements.

`CreateView` is resolved into [CreateViewCommand](CreateViewCommand.md) logical operator by [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical analysis rule.

## Creating Instance

`CreateView` takes the following to be created:

* <span id="child"> Child [LogicalPlan](LogicalPlan.md)
* <span id="userSpecifiedColumns"> User-specified columns (`Seq[(String, Option[String])]`)
* <span id="comment"> Optional Comment
* <span id="properties"> Properties (`Map[String, String]`)
* <span id="originalText"> Optional "Original Text"
* <span id="query"> [Logical Query Plan](LogicalPlan.md)
* <span id="allowExisting"> `allowExisting` flag
* <span id="replace"> `replace` flag

`CreateView` is created when:

* `SparkSqlAstBuilder` is requested to [parse a CREATE VIEW AS statement](../sql/SparkSqlAstBuilder.md#visitCreateView)
