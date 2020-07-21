# EXPLAIN Command Improved

Spark 3 supports new output modes for `EXPLAIN` SQL statement and [Dataset.explain](../spark-sql-dataset-operators.md#explain) operator.

```text
EXPLAIN (LOGICAL | FORMATTED | EXTENDED | CODEGEN | COST)?
  statement
```

!!! warning "Operation not allowed: EXPLAIN LOGICAL"
    `EXPLAIN LOGICAL` is currently not supported.

[SparkSqlAstBuilder](../sql/SparkSqlAstBuilder.md#visitExplain) converts `EXPLAIN` statements into [ExplainCommand](../logical-operators/ExplainCommand.md) logical commands (with a corresponding mode).

!!! note "JIRA issue"
    JIRA issue: [[SPARK-27395] New format of EXPLAIN command](https://issues.apache.org/jira/browse/SPARK-27395)

## Example 1

```sql
EXPLAIN
SELECT key, max(val)
FROM
    SELECT col1 key, col2 val
    FROM VALUES (0, 0), (0, 1), (1, 2))
WHERE key > 0
GROUP BY key
HAVING max(val) > 0
```

```text
== Physical Plan ==
*(2) Project [key#10, max(val)#20]
+- *(2) Filter (isnotnull(max(val#11)#23) AND (max(val#11)#23 > 0))
   +- *(2) HashAggregate(keys=[key#10], functions=[max(val#11)])
      +- Exchange hashpartitioning(key#10, 200), true, [id=#32]
         +- *(1) HashAggregate(keys=[key#10], functions=[partial_max(val#11)])
            +- *(1) LocalTableScan [key#10, val#11]
```
