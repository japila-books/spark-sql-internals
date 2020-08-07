# Explaining Query Plans Improved

**New in 3.0.0**

Spark 3 comes with new output modes for explaining query plans (using [EXPLAIN](../sql/SparkSqlAstBuilder.md#visitExplain) SQL statement or [Dataset.explain](../spark-sql-dataset-operators.md#explain) operator).

!!! tip "EXPLAIN SQL Examples"
    Visit [explain.sql](https://github.com/apache/spark/blob/c9748d4f00c505053c81c8aeb69f7166e92f82a6/sql/core/src/test/resources/sql-tests/inputs/explain.sql) for SQL examples of `EXPLAIN` SQL statement.

??? note "SPARK-27395"
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

## Example 2

```sql
EXPLAIN FORMATTED
SELECT (SELECT avg(a) FROM s1) + (SELECT avg(a) FROM s1)
FROM s1
LIMIT 1;
```
