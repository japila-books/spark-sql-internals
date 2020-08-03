title: CheckAnalysis

# CheckAnalysis -- Analysis Validation

`CheckAnalysis` defines <<checkAnalysis, checkAnalysis>> method that [Logical Analyzer](Analyzer.md) uses to check if a spark-sql-LogicalPlan.md[logical plan] is correct (after all the transformations) by applying <<checkAnalysis-validations, validation rules>> and in the end marking it as analyzed.

NOTE: An analyzed logical plan is correct and ready for execution.

`CheckAnalysis` defines <<extendedCheckRules, extendedCheckRules extension point>> that allows for extra analysis check rules.

=== [[checkAnalysis]] Validating Analysis of Logical Plan (and Marking Plan As Analyzed) -- `checkAnalysis` Method

[source, scala]
----
checkAnalysis(plan: LogicalPlan): Unit
----

`checkAnalysis` recursively checks the correctness of the analysis of the input spark-sql-LogicalPlan.md[logical plan] and spark-sql-LogicalPlan.md#setAnalyzed[marks it as analyzed].

NOTE: `checkAnalysis` fails analysis when finds <<UnresolvedRelation, UnresolvedRelation>> in the input `LogicalPlan`...FIXME What else?

Internally, `checkAnalysis` processes nodes in the input `plan` (starting from the leafs, i.e. nodes down the operator tree).

`checkAnalysis` skips spark-sql-LogicalPlan.md#analyzed[logical plans that have already undergo analysis].

[[checkAnalysis-validations]]
.checkAnalysis's Validation Rules (in the order of execution)
[width="100%",cols="1,2",options="header"]
|===
| LogicalPlan/Operator
| Behaviour

| [[UnresolvedRelation]] spark-sql-LogicalPlan-UnresolvedRelation.md[UnresolvedRelation]
a| Fails analysis with the error message:

```
Table or view not found: [tableIdentifier]
```

| Unresolved spark-sql-Expression-Attribute.md[Attribute]
a| Fails analysis with the error message:

```
cannot resolve '[expr]' given input columns: [from]
```

| expressions/Expression.md[Expression] with expressions/Expression.md#checkInputDataTypes[incorrect input data types]
a| Fails analysis with the error message:

```
cannot resolve '[expr]' due to data type mismatch: [message]
```

| Unresolved `Cast`
a| Fails analysis with the error message:

```
invalid cast from [dataType] to [dataType]
```

| [[Grouping]] `Grouping`
a| Fails analysis with the error message:

```
grouping() can only be used with GroupingSets/Cube/Rollup
```

| [[GroupingID]] `GroupingID`
a| Fails analysis with the error message:

```
grouping_id() can only be used with GroupingSets/Cube/Rollup
```

| [[WindowExpression-AggregateExpression-isDistinct]] [WindowExpressions](expressions/WindowExpression.md) with a [AggregateExpression](expressions/AggregateExpression.md) window function with [isDistinct](expressions/AggregateExpression.md#isDistinct) flag on
a| Fails analysis with the error message:

```text
Distinct window functions are not supported: [w]
```

Example:

```text
val windowedDistinctCountExpr = "COUNT(DISTINCT 1) OVER (PARTITION BY value)"
scala> spark.emptyDataset[Int].selectExpr(windowedDistinctCountExpr)
org.apache.spark.sql.AnalysisException: Distinct window functions are not supported: count(distinct 1) windowspecdefinition(value#95, ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);;
Project [COUNT(1) OVER (PARTITION BY value UnspecifiedFrame)#97L]
+- Project [value#95, COUNT(1) OVER (PARTITION BY value UnspecifiedFrame)#97L, COUNT(1) OVER (PARTITION BY value UnspecifiedFrame)#97L]
   +- Window [count(distinct 1) windowspecdefinition(value#95, ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS COUNT(1) OVER (PARTITION BY value UnspecifiedFrame)#97L], [value#95]
      +- Project [value#95]
         +- LocalRelation <empty>, [value#95]

  at org.apache.spark.sql.catalyst.analysis.CheckAnalysis$class.failAnalysis(CheckAnalysis.scala:40)
  at org.apache.spark.sql.catalyst.analysis.Analyzer.failAnalysis(Analyzer.scala:90)
  at org.apache.spark.sql.catalyst.analysis.CheckAnalysis$$anonfun$checkAnalysis$1$$anonfun$apply$2.applyOrElse(CheckAnalysis.scala:108)
  at org.apache.spark.sql.catalyst.analysis.CheckAnalysis$$anonfun$checkAnalysis$1$$anonfun$apply$2.applyOrElse(CheckAnalysis.scala:86)
```

| [[WindowExpression-OffsetWindowFunction]] <<spark-sql-Expression-WindowExpression.md#, WindowExpressions>> with a <<spark-sql-Expression-OffsetWindowFunction.md#, OffsetWindowFunction>> window function with an empty <<spark-sql-Expression-WindowSpecDefinition.md#orderSpec, order specification>> or a non-offset <<spark-sql-Expression-WindowSpecDefinition.md#frameSpecification, window frame specification>>
a| Fails analysis with the error message:

[options="wrap"]
----
An offset window function can only be evaluated in an ordered row-based window frame with a single offset: [windowExpr]
----

| [[WindowExpression]] <<spark-sql-Expression-WindowExpression.md#, WindowExpressions>> with a <<spark-sql-Expression-WindowExpression.md#windowFunction, window function>> that is not one of the following expressions: [AggregateExpression](expressions/AggregateExpression.md), <<spark-sql-Expression-AggregateWindowFunction.md#, AggregateWindowFunction>> or <<spark-sql-Expression-OffsetWindowFunction.md#, OffsetWindowFunction>>
a| Fails analysis with the error message:

```
Expression '[e]' not supported within a window function.
```

| [[deterministic]] spark-sql-Expression-Nondeterministic.md[Nondeterministic] expressions
| FIXME

| [[UnresolvedHint]] spark-sql-LogicalPlan-UnresolvedHint.md[UnresolvedHint]
| FIXME

| FIXME
| FIXME
|===

After <<checkAnalysis-validations, the validations>>, `checkAnalysis` executes <<extendedCheckRules, additional check rules for correct analysis>>.

`checkAnalysis` then checks if `plan` is analyzed correctly (i.e. no logical plans are left unresolved). If there is one, `checkAnalysis` fails the analysis with `AnalysisException` and the following error message:

```
unresolved operator [o.simpleString]
```

In the end, `checkAnalysis` spark-sql-LogicalPlan.md#setAnalyzed[marks the entire logical plan as analyzed].

`checkAnalysis` is used when:

* `QueryExecution` is requested to [create an analyzed logical plan and checks its correctness](QueryExecution.md#assertAnalyzed) (which happens mostly when a `Dataset` is spark-sql-Dataset.md#creating-instance[created])

* `ExpressionEncoder` does spark-sql-ExpressionEncoder.md#resolveAndBind[resolveAndBind]

* `ResolveAggregateFunctions` is executed (for `Sort` logical plan)

=== [[extendedCheckRules]] Extended Analysis Check Rules -- `extendedCheckRules` Extension Point

[source, scala]
----
extendedCheckRules: Seq[LogicalPlan => Unit]
----

`extendedCheckRules` is a collection of rules (functions) that <<checkAnalysis, checkAnalysis>> uses for custom analysis checks (after the <<checkAnalysis-validations, main validations>> have been executed).

NOTE: When a condition of a rule does not hold the function throws an `AnalysisException` directly or using `failAnalysis` method.

=== [[checkSubqueryExpression]] `checkSubqueryExpression` Internal Method

[source, scala]
----
checkSubqueryExpression(plan: LogicalPlan, expr: SubqueryExpression): Unit
----

`checkSubqueryExpression`...FIXME

NOTE: `checkSubqueryExpression` is used exclusively when `CheckAnalysis` is requested to <<checkAnalysis, validate analysis of a logical plan>> (for `SubqueryExpression` expressions).
