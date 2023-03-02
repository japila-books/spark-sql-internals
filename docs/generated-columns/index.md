# Generated Columns

[Spark SQL 3.4.0]({{ spark.jira }}/SPARK-41290) comes with support for `GENERATED ALWAYS AS` syntax for defining **Generated Columns** in `CREATE TABLE` and `REPLACE TABLE` statements for data sources that support it.

``` sql hl_lines="3"
CREATE TABLE default.example (
    time TIMESTAMP,
    date DATE GENERATED ALWAYS AS (CAST(time AS DATE))
)
```

Generated Columns are part of column definition.

``` antlr hl_lines="4"
colDefinitionOption
    : NOT NULL
    | defaultExpression
    | generationExpression
    | commentSpec
    ;

generationExpression
    : GENERATED ALWAYS AS '(' expression ')'
    ;
```
