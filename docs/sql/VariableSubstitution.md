# VariableSubstitution

`VariableSubstitution` allows for [variable substitution](#substitute) in SQL commands (in [SparkSqlParser](SparkSqlParser.md#substitutor) and Spark Thrift Server).

!!! note
    `VariableSubstitution` is meant for SQL commands since in programming languages there are other means like [String Interpolation](https://docs.scala-lang.org/overviews/core/string-interpolation.html) in Scala.

## Demo

=== "SQL"

    ```sql
    SET values = VALUES 1,2,3;
    ```

    ```sql
    SELECT * FROM ${values};
    ```

=== "Scala"

    ```scala
    import org.apache.spark.sql.internal.VariableSubstitution
    val substitutor = new VariableSubstitution()
    substitutor.substitute(...)
    ```

## Creating Instance

`VariableSubstitution` takes no arguments to be created.

`VariableSubstitution` is created when:

* `SparkSqlParser` is [created](SparkSqlParser.md#substitutor)
* `SparkExecuteStatementOperation` (Spark Thrift Server) is created
* `SparkSQLDriver` (Spark Thrift Server) is executed

## <span id="reader"> ConfigReader

`VariableSubstitution` creates a `ConfigReader` (Spark Core) when [created](#creating-instance) (for [Variable Substitution](#substitute)).

This `ConfigReader` uses the active [SQLConf](../SQLConf.md) to look up keys (_variables_) first. It then binds the same variable provider to handle the following prefixes:

* `spark`
* `sparkconf`
* `hivevar`
* `hiveconf`

!!! note
    By default, the `ConfigReader` handles the other two prefixes:

    * `env` (for environment variables)
    * `system` (for Java system properties)

    If a reference cannot be resolved, the original string will be retained.

## <span id="substitute"> Variable Substitution

```scala
substitute(
  input: String): String
```

With [spark.sql.variable.substitute](../SQLConf.md#spark.sql.variable.substitute) enabled, `substitute` requests the [ConfigReader](#reader) to substitute variables. Otherwise, `substitute` does nothing and simply returns the given `input`.

`substitute` is used when:

* `SparkSqlParser` is requested to [parse a command](SparkSqlParser.md#parse)
* `SparkExecuteStatementOperation` (Spark Thrift Server) is created
* `SparkSQLDriver` (Spark Thrift Server) is executed
