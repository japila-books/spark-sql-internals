# CreateStruct Function Builder

`CreateStruct` is a [function builder](../FunctionRegistry.md#expressions) (e.g. `Seq[Expression] => Expression`) that can <<apply, create CreateNamedStruct expressions>> and is the <<registryEntry, metadata>> of the <<FunctionRegistry.md#struct, struct>> function.

=== [[apply]] Creating CreateNamedStruct Expression -- `apply` Method

[source, scala]
----
apply(children: Seq[Expression]): CreateNamedStruct
----

NOTE: `apply` is part of Scala's https://www.scala-lang.org/api/2.11.12/index.html#scala.Function1[scala.Function1] contract to create a function of one parameter (e.g. `Seq[Expression]`).

`apply` creates a <<spark-sql-Expression-CreateNamedStruct.md#creating-instance, CreateNamedStruct>> expression with the input `children` <<expressions/Expression.md#, expressions>> as follows:

* For <<expressions/NamedExpression.md#, NamedExpression>> expressions that are <<expressions/Expression.md#resolved, resolved>>, `apply` creates a pair of a <<spark-sql-Expression-Literal.md#apply, Literal>> expression (with the <<expressions/NamedExpression.md#name, name>> of the `NamedExpression`) and the `NamedExpression` itself

* For <<expressions/NamedExpression.md#, NamedExpression>> expressions that are not <<expressions/Expression.md#resolved, resolved>> yet, `apply` creates a pair of a `NamePlaceholder` expression and the `NamedExpression` itself

* For all other <<expressions/Expression.md#, expressions>>, `apply` creates a pair of a <<spark-sql-Expression-Literal.md#apply, Literal>> expression (with the value as `col[index]`) and the `Expression` itself

`apply` is used when:

* `ResolveReferences` logical resolution rule is requested to [expandStarExpression](../logical-analysis-rules/ResolveReferences.md#expandStarExpression)

* `InConversion` type coercion rule is requested to `coerceTypes`

* `ExpressionEncoder` is requested to [create an ExpressionEncoder for a tuple](../ExpressionEncoder.md#tuple)

* `Stack` generator expression is requested to generate a Java source code

* `AstBuilder` is requested to parse a [struct](../sql/AstBuilder.md#visitStruct) and [row constructor](../sql/AstBuilder.md#visitRowConstructor)

* `ColumnStat` is requested to [statExprs](../cost-based-optimization/ColumnStat.md#statExprs)

* `KeyValueGroupedDataset` is requested to [aggUntyped](../basic-aggregation/KeyValueGroupedDataset.md#aggUntyped) (when [KeyValueGroupedDataset.agg](../basic-aggregation/KeyValueGroupedDataset.md#agg) typed operator is used)

* <<spark-sql-dataset-operators.md#joinWith, Dataset.joinWith>> typed transformation is used

* [struct](../functions/index.md#struct) standard function is used

* `SimpleTypedAggregateExpression` expression is requested `evaluateExpression` and `resultObjToRow`
