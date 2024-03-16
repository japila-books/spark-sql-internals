# Table-Valued Functions

**Table-Valued Functions (TFVs)** are functions that return a table (as a [LogicalPlan](../logical-operators/LogicalPlan.md)) that can be used anywhere that a regular (scalar) table is allowed.

Table functions behave similarly to views, but, as functions in general, table functions accept parameters.

!!! tip "Google BigQuery Documentation :fontawesome-solid-face-smile-wink:"
    Read up on table-valued functions in the official documentation of [Google BigQuery](https://cloud.google.com/bigquery/docs/reference/standard-sql/table-functions) (for a lack of a better documentation).

Spark SQL supports [Logical Operators](../logical-operators/LogicalPlan.md) and [Generator](../expressions/Generator.md) expressions as table-valued functions.

Name | Logical Operator | Generator Expression
-----|------------------|---------------------
 `range` | `Range` |
 `explode` | | `Explode`
 `explode_outer` | | `Explode`
 `inline` | | [Inline](../expressions/Inline.md)
 `inline_outer` | | [Inline](../expressions/Inline.md)
 `json_tuple` | | `JsonTuple`
 `posexplode` | | `PosExplode`
 `posexplode_outer` | | `PosExplode`
 `stack` | | `Stack`

Custom table-valued functions can be registered using [SparkSessionExtensions](../SparkSessionExtensions.md#injectTableFunction).

Spark SQL uses the [SimpleTableFunctionRegistry](../SimpleTableFunctionRegistry.md) to manage the [built-in table-valued functions](../TableFunctionRegistry.md#logicalPlans).
