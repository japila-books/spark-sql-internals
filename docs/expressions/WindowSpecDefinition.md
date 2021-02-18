# WindowSpecDefinition Unevaluable Expression

`WindowSpecDefinition` is an [unevaluable expression](Unevaluable.md).

`WindowSpecDefinition` is [created](#creating-instance) when:

* `AstBuilder` is requested to [parse a window specification](../sql/AstBuilder.md#visitWindowDef) in a SQL query

* [Column.over](../Column.md#over) operator is used

```text
import org.apache.spark.sql.expressions.Window
val byValueDesc = Window.partitionBy("value").orderBy($"value".desc)

val q = table.withColumn("count over window", count("*") over byValueDesc)

import org.apache.spark.sql.catalyst.expressions.WindowExpression
val windowExpr = q.queryExecution
  .logical
  .expressions(1)
  .children(0)
  .asInstanceOf[WindowExpression]

scala> windowExpr.windowSpec
res0: org.apache.spark.sql.catalyst.expressions.WindowSpecDefinition = windowspecdefinition('value, 'value DESC NULLS LAST, UnspecifiedFrame)
```

```text
import org.apache.spark.sql.catalyst.expressions.WindowSpecDefinition

Seq((0, "hello"), (1, "windows"))
  .toDF("id", "token")
  .createOrReplaceTempView("mytable")

val sqlText = """
  SELECT count(*) OVER myWindowSpec
  FROM mytable
  WINDOW
    myWindowSpec AS (
      PARTITION BY token
      ORDER BY id
      RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )
"""

import spark.sessionState.{analyzer,sqlParser}

scala> val parsedPlan = sqlParser.parsePlan(sqlText)
parsedPlan: org.apache.spark.sql.catalyst.plans.logical.LogicalPlan =
'WithWindowDefinition Map(myWindowSpec -> windowspecdefinition('token, 'id ASC NULLS FIRST, RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))
+- 'Project [unresolvedalias(unresolvedwindowexpression('count(1), WindowSpecReference(myWindowSpec)), None)]
   +- 'UnresolvedRelation `mytable`

import org.apache.spark.sql.catalyst.plans.logical.WithWindowDefinition
val myWindowSpec = parsedPlan.asInstanceOf[WithWindowDefinition].windowDefinitions("myWindowSpec")

scala> println(myWindowSpec)
windowspecdefinition('token, 'id ASC NULLS FIRST, RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

scala> println(myWindowSpec.sql)
(PARTITION BY `token` ORDER BY `id` ASC NULLS FIRST RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

scala> sql(sqlText)
res4: org.apache.spark.sql.DataFrame = [count(1) OVER (PARTITION BY token ORDER BY id ASC NULLS FIRST RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW): bigint]

scala> println(analyzer.execute(sqlParser.parsePlan(sqlText)))
Project [count(1) OVER (PARTITION BY token ORDER BY id ASC NULLS FIRST RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)#25L]
+- Project [token#13, id#12, count(1) OVER (PARTITION BY token ORDER BY id ASC NULLS FIRST RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)#25L, count(1) OVER (PARTITION BY token ORDER BY id ASC NULLS FIRST RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)#25L]
   +- Window [count(1) windowspecdefinition(token#13, id#12 ASC NULLS FIRST, RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS count(1) OVER (PARTITION BY token ORDER BY id ASC NULLS FIRST RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)#25L], [token#13], [id#12 ASC NULLS FIRST]
      +- Project [token#13, id#12]
         +- SubqueryAlias mytable
            +- Project [_1#9 AS id#12, _2#10 AS token#13]
               +- LocalRelation [_1#9, _2#10]
```

[[properties]]
.WindowSpecDefinition's Properties
[width="100%",cols="1,2",options="header"]
|===
| Name
| Description

| [[children]] `children`
| Window <<partitionSpec, partition>> and <<orderSpec, order>> specifications (for which `WindowExpression` was created).

| `dataType`
| Unsupported (i.e. reports a `UnsupportedOperationException`)

| `foldable`
| Disabled (i.e. `false`)

| `nullable`
| Enabled (i.e. `true`)

| `resolved`
| Enabled when <<children, children>> are and the input [DataType](../DataType.md) is valid and the input [frameSpecification](#frameSpecification) is a `SpecifiedWindowFrame`.

| `sql`
a| Contains `PARTITION BY` with comma-separated elements of <<partitionSpec, partitionSpec>> (if defined) with `ORDER BY` with comma-separated elements of <<orderSpec, orderSpec>> (if defined) followed by <<frameSpecification, frameSpecification>>.

[options="wrap"]
----
(PARTITION BY `token` ORDER BY `id` ASC NULLS FIRST RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
----
|===

## Creating Instance

`WindowSpecDefinition` takes the following when created:

* [[partitionSpec]] <<Expression.md#, Expressions>> for window partition specification
* [[orderSpec]] Window order specifications (as `SortOrder` unary expressions)
* [[frameSpecification]] Window frame specification (as `WindowFrame`)

=== [[isValidFrameType]] Validating Data Type Of Window Order-- `isValidFrameType` Internal Method

[source, scala]
----
isValidFrameType(ft: DataType): Boolean
----

`isValidFrameType` is positive (`true`) when the data type of the <<orderSpec, window order specification>> and the input `ft` [data type](../DataType.md) are as follows:

* [DateType](../DataType.md#DateType) and [IntegerType](../DataType.md#IntegerType)

* [TimestampType](../DataType.md#TimestampType) and [CalendarIntervalType](../DataType.md#CalendarIntervalType)

* Equal

Otherwise, `isValidFrameType` is negative (`false`).

NOTE: `isValidFrameType` is used exclusively when `WindowSpecDefinition` is requested to <<checkInputDataTypes, checkInputDataTypes>> (with `RangeFrame` as the <<frameSpecification, window frame specification>>)

=== [[checkInputDataTypes]] Checking Input Data Types -- `checkInputDataTypes` Method

[source, scala]
----
checkInputDataTypes(): TypeCheckResult
----

`checkInputDataTypes` is part of the [Expression](Expression.md#checkInputDataTypes) abstraction.

`checkInputDataTypes`...FIXME
