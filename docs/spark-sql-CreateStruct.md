# CreateStruct Function Builder

`CreateStruct` is a <<spark-sql-FunctionRegistry.md#expressions, function builder>> (e.g. `Seq[Expression] => Expression`) that can <<apply, create CreateNamedStruct expressions>> and is the <<registryEntry, metadata>> of the <<spark-sql-FunctionRegistry.md#struct, struct>> function.

=== [[registryEntry]] Metadata of struct Function -- `registryEntry` Property

[source, scala]
----
registryEntry: (String, (ExpressionInfo, FunctionBuilder))
----

`registryEntry`...FIXME

NOTE: `registryEntry` is used exclusively when `FunctionRegistry` is requested for the <<spark-sql-FunctionRegistry.md#expressions, function expression registry>>.

=== [[apply]] Creating CreateNamedStruct Expression -- `apply` Method

[source, scala]
----
apply(children: Seq[Expression]): CreateNamedStruct
----

NOTE: `apply` is part of Scala's https://www.scala-lang.org/api/2.11.12/index.html#scala.Function1[scala.Function1] contract to create a function of one parameter (e.g. `Seq[Expression]`).

`apply` creates a <<spark-sql-Expression-CreateNamedStruct.md#creating-instance, CreateNamedStruct>> expression with the input `children` <<expressions/Expression.md#, expressions>> as follows:

* For <<spark-sql-Expression-NamedExpression.md#, NamedExpression>> expressions that are <<expressions/Expression.md#resolved, resolved>>, `apply` creates a pair of a <<spark-sql-Expression-Literal.md#apply, Literal>> expression (with the <<spark-sql-Expression-NamedExpression.md#name, name>> of the `NamedExpression`) and the `NamedExpression` itself

* For <<spark-sql-Expression-NamedExpression.md#, NamedExpression>> expressions that are not <<expressions/Expression.md#resolved, resolved>> yet, `apply` creates a pair of a `NamePlaceholder` expression and the `NamedExpression` itself

* For all other <<expressions/Expression.md#, expressions>>, `apply` creates a pair of a <<spark-sql-Expression-Literal.md#apply, Literal>> expression (with the value as `col[index]`) and the `Expression` itself

[NOTE]
====
`apply` is used when:

* `ResolveReferences` logical resolution rule is requested to <<spark-sql-Analyzer-ResolveReferences.md#expandStarExpression, expandStarExpression>>

* `InConversion` type coercion rule is requested to <<spark-sql-Analyzer-TypeCoercionRule-InConversion.md#coerceTypes, coerceTypes>>

* `ExpressionEncoder` is requested to <<spark-sql-ExpressionEncoder.md#tuple, create an ExpressionEncoder for a tuple>>

* `Stack` generator expression is requested to <<spark-sql-Expression-Stack.md#doGenCode, generate a Java source code>>

* `AstBuilder` is requested to parse a <<spark-sql-AstBuilder.md#visitStruct, struct>> and <<spark-sql-AstBuilder.md#visitRowConstructor, row constructor>>

* `ColumnStat` is requested to <<spark-sql-ColumnStat.md#statExprs, statExprs>>

* `KeyValueGroupedDataset` is requested to <<spark-sql-KeyValueGroupedDataset.md#aggUntyped, aggUntyped>> (when <<spark-sql-KeyValueGroupedDataset.md#agg, KeyValueGroupedDataset.agg>> typed operator is used)

* <<spark-sql-dataset-operators.md#joinWith, Dataset.joinWith>> typed transformation is used

* <<spark-sql-functions.md#struct, struct>> standard function is used

* `SimpleTypedAggregateExpression` expression is requested for the <<spark-sql-Expression-SimpleTypedAggregateExpression.md#evaluateExpression, evaluateExpression>> and <<spark-sql-Expression-SimpleTypedAggregateExpression.md#resultObjToRow, resultObjToRow>>
====
