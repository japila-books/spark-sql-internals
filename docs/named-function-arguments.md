# Named Function Arguments

**Named Function Arguments** is a new feature in Spark SQL 3.5 that allows specifying function arguments by name in some [built-in](#built-in-functions) and [table-valued functions](table-valued-functions/index.md) in [SQL statements](sql/AstBuilder.md#visitTableValuedFunction).

Named Function Arguments is particularly important for longer parameter lists in SQL functions with many arguments with the default values.

Named Function Arguments can be specified using `=>` (_fat arrow_).

Named Function Arguments is controlled by [spark.sql.allowNamedFunctionArguments](configuration-properties.md#spark.sql.allowNamedFunctionArguments) configuration property.

!!! note
    User-defined functions and most of the [built-in functions](FunctionRegistry.md#expression) are not yet supported.

??? note "[SPARK-44059] Add named argument support for SQL functions"
    Named Function Arguments is added in 3.5.0 as part of [SPARK-44059]({{ spark.jira }}/SPARK-44059).

## Built-in Functions

Named Function Arguments is supported by the following built-in functions.

Function Name | Function Argument Name(s) | ExpressionBuilder
--------------|---------------------------|------------------
 `explode` | `collection` | `ExplodeExpressionBuilder` and `ExplodeGeneratorBuilderBase`
 `explode_outer` | `collection` | `ExplodeExpressionBuilder` and `ExplodeGeneratorBuilderBase`
 `mask` | `str`<br>`upperChar`<br>`lowerChar`<br>`digitChar`<br>`otherChar` | `MaskExpressionBuilder`
 `count_min_sketch` | `column`<br>`epsilon`<br>`confidence`<br>`seed` | `CountMinSketchAggExpressionBuilder`

## Demo

```sql
-- table-valued function
SELECT * FROM explode(collection => array(10, 20))
```

```sql
-- table-valued function
SELECT * FROM pos_explode(collection => array(10, 20))
```

```sql
-- built-in standard function
SELECT explode(collection => array(10, 20))
```

```text
scala> sql(""" SELECT e.col AS n FROM explode(collection => array(10, 20)) e """).show(false)
+---+
|n  |
+---+
|10 |
|20 |
+---+
```
