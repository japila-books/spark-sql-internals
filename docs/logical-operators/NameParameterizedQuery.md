---
title: NameParameterizedQuery
---

# NameParameterizedQuery Unary Logical Operator

`NameParameterizedQuery` is a [ParameterizedQuery](ParameterizedQuery.md) logical operator that represents a parameterized query with named parameters.

## Creating Instance

`NameParameterizedQuery` takes the following to be created:

* <span id="child"> Child [LogicalPlan](LogicalPlan.md)
* <span id="args"> Arguments (`Map[String, Expression]`)

`NameParameterizedQuery` is created when:

* `SparkSession` is requested to [sql](../SparkSession.md#sql)
