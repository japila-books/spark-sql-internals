---
title: ExtractPythonUDFs
---

# ExtractPythonUDFs Logical Optimization

`ExtractPythonUDFs` is a logical optimization (`Rule[LogicalPlan]`) that "executes" (_replaces_) `PythonUDF`s as [BaseEvalPython](../logical-operators/BaseEvalPython.md)s.

## Executing Rule { #apply }

??? note "Rule"

    ```scala
    apply(
      plan: LogicalPlan): LogicalPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` finds operators with [PYTHON_UDF](../catalyst/TreePattern.md#PYTHON_UDF) tree pattern (with the children first and this operator next) and [extract](#extract) from the given [LogicalPlan](../logical-operators/LogicalPlan.md).

??? note "Skips correlated subqueries"
    `apply` skips correlated subqueries.

### extract

```scala
extract(
  plan: LogicalPlan): LogicalPlan
```

`extract` collects `PythonUDF`s (from the given [LogicalPlan](../logical-operators/LogicalPlan.md) recursively) and rewrites them all to a single-type [BaseEvalPython](../logical-operators/BaseEvalPython.md) based on a PythonUDF eval type.

BaseEvalPython | PythonUDF Eval Type
---------------|--------------------
 [ArrowEvalPython](../logical-operators/ArrowEvalPython.md) | `SQL_SCALAR_PANDAS_UDF` or `SQL_SCALAR_PANDAS_ITER_UDF`
 `BatchEvalPython` | `SQL_BATCHED_UDF`

<!---
## Review Me

[[apply]]
`ExtractPythonUDFs` is a *physical query optimization* (aka _physical query preparation rule_ or simply _preparation rule_) that `QueryExecution` [uses](../QueryExecution.md#preparations) to optimize the physical plan of a structured query by <<extract, extracting Python UDFs from a physical query plan>> (excluding `FlatMapGroupsInPandasExec` operators that it simply skips over).

Technically, `ExtractPythonUDFs` is just a catalyst/Rule.md[Catalyst rule] for transforming SparkPlan.md[physical query plans], i.e. `Rule[SparkPlan]`.

`ExtractPythonUDFs` is part of [preparations](../QueryExecution.md#preparations) batch of physical query plan rules and is executed when `QueryExecution` is requested for the [optimized physical query plan](../QueryExecution.md#executedPlan) (i.e. in *executedPlan* phase of a query execution).
-->
