# Parameterized Queries

**Parameterized Queries** (_Parameterized SQL_) allows Spark SQL developers to write SQL statements with parameter markers to be bound at execution time with parameters (literals) by name or position.

Parameterized Queries are supposed to improve security and reusability, and help preventing SQL injection attacks for applications that generate SQL at runtime (e.g., based on a user's selections, which is often done via a user interface).

Parameterized Queries supports named and positional parameters. [SQL parser](../SessionState.md#sqlParser) can recognize them using the following:

* `:` (colon) followed by name for named parameters
* `?` (question mark) for positional parameters

=== "Named Parameters"

    ```sql
    WITH a AS (SELECT 1 c)
    SELECT *
    FROM a
    LIMIT :limitA
    ```

=== "Positional Parameters"

    ```sql
    WITH a AS (SELECT 1 c)
    SELECT *
    FROM a
    LIMIT ?
    ```

Parameterized Queries are executed using [SparkSession.sql](../SparkSession.md#sql) operator (marked as experimental).

```scala
sql(
  sqlText: String,
  args: Map[String, Any]): DataFrame
```

Parameterized Queries feature was introduced in [\[SPARK-41271\] Parameterized SQL]({{ spark.jira }}/SPARK-41271).

## Internals

* [BindParameters Logical Analysis Rule](../logical-analysis-rules/BindParameters.md)
* [ParameterizedQuery](../logical-operators/ParameterizedQuery.md) logical unary nodes
