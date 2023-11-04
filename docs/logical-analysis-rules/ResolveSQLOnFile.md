---
title: ResolveSQLOnFile
---

# ResolveSQLOnFile Logical Evaluation Rule

`ResolveSQLOnFile` is an [extended resolution rule](../Analyzer.md#extendedResolutionRules) for [hive](../hive/HiveSessionStateBuilder.md#analyzer) and [non-hive](../BaseSessionStateBuilder.md#analyzer) sessions for [Direct Queries on Files](../direct-queries-on-files/index.md).

`ResolveSQLOnFile` is a [logical rule](index.md).

## Creating Instance

`ResolveSQLOnFile` takes the following to be created:

* <span id="sparkSession"> [SparkSession](../SparkSession.md)

`ResolveSQLOnFile` is created when:

* `HiveSessionStateBuilder` is requested for the [Analyzer](../hive/HiveSessionStateBuilder.md#analyzer)
* `BaseSessionStateBuilder` is requested for the [Analyzer](../BaseSessionStateBuilder.md#analyzer)

## Executing Rule { #apply }

??? note "Rule"

    ```scala
    apply(
      plan: LogicalPlan): LogicalPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` handles the following logical operators:

* `RelationTimeTravel`
* [UnresolvedRelation](../logical-operators/UnresolvedRelation.md)

### maybeSQLFile { #maybeSQLFile }

```scala
maybeSQLFile(
  u: UnresolvedRelation): Boolean
```

`maybeSQLFile` holds `true` when the following are all `true`:

1. [spark.sql.runSQLOnFiles](../configuration-properties.md#spark.sql.runSQLOnFiles) is enabled
1. The given [UnresolvedRelation](../logical-operators/UnresolvedRelation.md) is two-part (i.e., uses a single `.` to separate the data source part from the path itself, ```datasource`.`path```).
