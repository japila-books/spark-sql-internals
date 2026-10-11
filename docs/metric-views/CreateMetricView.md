---
title: CreateMetricView
---

# CreateMetricView Unary Logical Operator

`CreateMetricView` is a [unary logical operator](../logical-operators/LogicalPlan.md#UnaryCommand) that represents [CREATE VIEW WITH METRICS](../sql/SparkSqlAstBuilder.md#visitCreateMetricView) SQL statement.

`CreateMetricView` is resolved to the following operators:

* [CreateMetricViewCommand](CreateMetricViewCommand.md) unary runnable command for metric views on the session catalog (by [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical analysis rule).
* [CreateV2MetricViewExec](CreateV2MetricViewExec.md) physical command operator for metric views on a non-session v2 catalog (by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy).

## Creating Instance

`CreateMetricView` takes the following to be created:

* <span id="child"> Child [logical operator](../logical-operators/LogicalPlan.md)
* <span id="userSpecifiedColumns"> User-specified columns
* <span id="comment"> Optional comment
* <span id="properties"> Properties
* <span id="originalText"> Original SQL Text
* <span id="allowExisting"> `allowExisting` flag
* <span id="replace"> `replace` flag

`CreateMetricView` is created when:

* `SparkSqlAstBuilder` is requested to [parse a `CREATE VIEW WITH METRICS` SQL statement](../sql/SparkSqlAstBuilder.md#visitCreateMetricView)
