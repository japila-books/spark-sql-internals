# Catalyst Expressions

`Expression` is an [extension](#contract) of the [TreeNode](../catalyst/TreeNode.md) abstraction for [executable nodes](#implementations).

`Expression` is a executable [node](../catalyst/TreeNode.md) (in a Catalyst multi-tree) that can be [evaluated](#eval) to a value for an input row (e.g. produces a JVM object for an [InternalRow](../spark-sql-InternalRow.md)).

`Expression` is often referred to as a **Catalyst expression**, but it is _simply_ built using the [Catalyst Tree Manipulation Framework](../catalyst/index.md).

```scala
// evaluating an expression
// Use Literal expression to create an expression from a Scala object
import org.apache.spark.sql.catalyst.expressions.{Expression, Literal}
val e: Expression = Literal("hello")

import org.apache.spark.sql.catalyst.expressions.EmptyRow
val v: Any = e.eval(EmptyRow)

// Convert to Scala's String
import org.apache.spark.unsafe.types.UTF8String
val s = v.asInstanceOf[UTF8String].toString
assert(s == "hello")
```

`Expression` can [generate a Java source code](#genCode) that is then used in code-gen non-interpreted evaluation.

[[specialized-expressions]]
.Specialized Expressions
[cols="1,2,2,1",options="header",width="100%"]
|===
| Name
| Scala Kind
| Behaviour
| Examples

| [[BinaryExpression]] `BinaryExpression`
| abstract class
|
a|

* spark-sql-Expression-UnixTimestamp.md[UnixTimestamp]

| [[CodegenFallback]] spark-sql-Expression-CodegenFallback.md[CodegenFallback]
| trait
| Does not support code generation and falls back to interpreted mode
a|

* spark-sql-Expression-CallMethodViaReflection.md[CallMethodViaReflection]

| <<spark-sql-Expression-ExpectsInputTypes.md#, ExpectsInputTypes>>
| trait
|
| [[ExpectsInputTypes]]

| [[ExtractValue]] `ExtractValue`
| trait
| Marks `UnresolvedAliases` to be resolved to spark-sql-Expression-Alias.md[Aliases] with "pretty" SQLs when [ResolveAliases](../logical-analysis-rules/ResolveAliases.md#assignAliases) is executed
a|

* spark-sql-Expression-GetArrayItem.md[GetArrayItem]

* spark-sql-Expression-GetArrayStructFields.md[GetArrayStructFields]

* spark-sql-Expression-GetMapValue.md[GetMapValue]

* spark-sql-Expression-GetStructField.md[GetStructField]

| [[LeafExpression]] `LeafExpression`
| abstract class
| Has no [child expressions](../catalyst/TreeNode.md#children) (and hence "terminates" the expression tree).
a|

* spark-sql-Expression-Attribute.md[Attribute]
* spark-sql-Expression-Literal.md[Literal]

| [[NamedExpression]] spark-sql-Expression-NamedExpression.md[NamedExpression]
|
| Can later be referenced in a dataflow graph.
|

| [[Nondeterministic]] spark-sql-Expression-Nondeterministic.md[Nondeterministic]
| trait
|
|

| [[NonSQLExpression]] `NonSQLExpression`
| trait
| Expression with no SQL representation

Gives the only custom <<sql, sql>> method that is non-overridable (i.e. `final`).

When requested <<sql, SQL representation>>, `NonSQLExpression` transforms spark-sql-Expression-Attribute.md[Attributes] to be ``PrettyAttribute``s to build text representation.
a|

* spark-sql-Expression-ScalaUDAF.md[ScalaUDAF]
* spark-sql-Expression-StaticInvoke.md[StaticInvoke]
* spark-sql-Expression-TimeWindow.md[TimeWindow]

| [[Predicate]] `Predicate`
| trait
| Result expressions/Expression.md#dataType[data type] is always spark-sql-DataType.md#BooleanType[boolean]
a|
* `And`
* `AtLeastNNonNulls`
* spark-sql-Expression-Exists.md[Exists]
* spark-sql-Expression-In.md[In]
* spark-sql-Expression-InSet.md[InSet]

| [[TernaryExpression]] `TernaryExpression`
| abstract class
|
|

| [[TimeZoneAwareExpression]] `TimeZoneAwareExpression`
| trait
| Timezone-aware expressions
a|

* spark-sql-Expression-UnixTimestamp.md[UnixTimestamp]
* spark-sql-Expression-JsonToStructs.md[JsonToStructs]

| [[UnaryExpression]] <<spark-sql-Expression-UnaryExpression.md#, UnaryExpression>>
| abstract class
|
a|

* spark-sql-Expression-Generator.md#ExplodeBase[ExplodeBase]
* spark-sql-Expression-Inline.md[Inline]
* spark-sql-Expression-JsonToStructs.md[JsonToStructs]

| [Unevaluable](Unevaluable.md)
| trait
a| [[Unevaluable]] Cannot be evaluated to produce a value (neither in <<expressions/Expression.md#eval, interpreted>> nor <<expressions/Expression.md#doGenCode, code-generated>> expression evaluations), i.e. <<eval, eval>> and <<doGenCode, doGenCode>> are not supported and simply report an `UnsupportedOperationException`.

```
/**
Example: Analysis failure due to an Unevaluable expression
UnresolvedFunction is an Unevaluable expression
Using Catalyst DSL to create a UnresolvedFunction
*/
import org.apache.spark.sql.catalyst.dsl.expressions._
val f = 'f.function()

import org.apache.spark.sql.catalyst.dsl.plans._
val logicalPlan = table("t1").select(f)
scala> println(logicalPlan.numberedTreeString)
00 'Project [unresolvedalias('f(), None)]
01 +- 'UnresolvedRelation `t1`

scala> spark.sessionState.analyzer.execute(logicalPlan)
org.apache.spark.sql.AnalysisException: Undefined function: 'f'. This function is neither a registered temporary function nor a permanent function registered in the database 'default'.;
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15$$anonfun$applyOrElse$49.apply(Analyzer.scala:1198)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15$$anonfun$applyOrElse$49.apply(Analyzer.scala:1198)
  at org.apache.spark.sql.catalyst.analysis.package$.withPosition(package.scala:48)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15.applyOrElse(Analyzer.scala:1197)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15.applyOrElse(Analyzer.scala:1195)
```

a|

* [AggregateExpression](AggregateExpression.md)
* `CurrentDatabase`
* [TimeWindow](TimeWindow.md)
* [UnresolvedFunction](UnresolvedFunction.md)
* [WindowExpression](WindowExpression.md)
* [WindowSpecDefinition](WindowSpecDefinition.md)
|===

## <span id="deterministic"> deterministic Flag

`Expression` is *deterministic* when evaluates to the same result for the same input(s). An expression is deterministic if all the [child expressions](../catalyst/TreeNode.md#children) are (which for <<LeafExpression, leaf expressions>> with no child expressions is always true).

NOTE: A deterministic expression is like a https://en.wikipedia.org/wiki/Pure_function[pure function] in functional programming languages.

```text
val e = $"a".expr
scala> :type e
org.apache.spark.sql.catalyst.expressions.Expression

scala> println(e.deterministic)
true
```

NOTE: Non-deterministic expressions are not allowed in some logical operators and are excluded in some optimizations.

=== [[contract]] Expression Contract

[source, scala]
----
package org.apache.spark.sql.catalyst.expressions

abstract class Expression extends TreeNode[Expression] {
  // only required methods that have no implementation
  def dataType: DataType
  def doGenCode(ctx: CodegenContext, ev: ExprCode): ExprCode
  def eval(input: InternalRow = EmptyRow): Any
  def nullable: Boolean
}
----

.(Subset of) Expression Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| [[canonicalized]] `canonicalized`
|

| [[checkInputDataTypes]] `checkInputDataTypes`
| Verifies (checks the correctness of) the input data types

| [[childrenResolved]] `childrenResolved`
|

| [[dataType]] `dataType`
| spark-sql-DataType.md[Data type] of the result of evaluating an expression

| [[doGenCode]] `doGenCode`
| *Code-generated expression evaluation* that generates a Java source code (that is used to evaluate the expression in a more optimized way not directly using <<eval, eval>>).

Used when `Expression` is requested to <<genCode, genCode>>.

| [[eval]] `eval`
a| *Interpreted (non-code-generated) expression evaluation* that evaluates an expression to a JVM object for a given spark-sql-InternalRow.md[internal binary row] (without <<genCode, generating a corresponding Java code>>.)

NOTE: By default accepts `EmptyRow`, i.e. `null`.

`eval` is a slower "relative" of the <<genCode, code-generated (non-interpreted) expression evaluation>>.

| [[foldable]] `foldable`
|

| [[genCode]] `genCode`
| Generates the Java source code for *code-generated (non-interpreted) expression evaluation* (on an input spark-sql-InternalRow.md[internal row] in a more optimized way not directly using <<eval, eval>>).

Similar to <<doGenCode, doGenCode>> but supports expression reuse (aka spark-sql-subexpression-elimination.md[subexpression elimination]).

`genCode` is a faster "relative" of the <<eval, interpreted (non-code-generated) expression evaluation>>.

| [[nullable]] `nullable`
|

| [[prettyName]] `prettyName`
| User-facing name

| [[references]] `references`
|

| [[resolved]] `resolved`
|

| [[semanticEquals]] `semanticEquals`
|

| [[semanticHash]] `semanticHash`
|
|===

=== [[reduceCodeSize]] `reduceCodeSize` Internal Method

[source, scala]
----
reduceCodeSize(ctx: CodegenContext, eval: ExprCode): Unit
----

`reduceCodeSize` does its work only when all of the following are met:

. Length of the generate code is above 1024

. spark-sql-CodegenContext.md#INPUT_ROW[INPUT_ROW] of the input `CodegenContext` is defined

. spark-sql-CodegenContext.md#currentVars[currentVars] of the input `CodegenContext` is not defined

CAUTION: FIXME When would the above not be met? What's so special about such an expression?

`reduceCodeSize` sets the `value` of the input `ExprCode` to the spark-sql-CodegenContext.md#freshName[fresh term name] for the `value` name.

In the end, `reduceCodeSize` sets the code of the input `ExprCode` to the following:

```
[javaType] [newValue] = [funcFullName]([INPUT_ROW]);
```

The `funcFullName` is the spark-sql-CodegenContext.md#freshName[fresh term name] for the [name of the current expression node](../catalyst/TreeNode.md#nodeName).

TIP: Use the expression node name to search for the function that corresponds to the expression in a generated code.

NOTE: `reduceCodeSize` is used exclusively when `Expression` is requested to <<genCode, generate the Java source code for code-generated expression evaluation>>.

=== [[flatArguments]] `flatArguments` Method

[source, scala]
----
flatArguments: Iterator[Any]
----

`flatArguments`...FIXME

NOTE: `flatArguments` is used when...FIXME

=== [[sql]] SQL Representation -- `sql` Method

[source, scala]
----
sql: String
----

`sql` gives a SQL representation.

Internally, `sql` gives a text representation with <<prettyName, prettyName>> followed by `sql` of [children](../catalyst/TreeNode.md#children) in the round brackets and concatenated using the comma (`,`).

[source, scala]
----
import org.apache.spark.sql.catalyst.dsl.expressions._
import org.apache.spark.sql.catalyst.expressions.Sentences
val sentences = Sentences("Hi there! Good morning.", "en", "US")

import org.apache.spark.sql.catalyst.expressions.Expression
val expr: Expression = count("*") === 5 && count(sentences) === 5
scala> expr.sql
res0: String = ((count('*') = 5) AND (count(sentences('Hi there! Good morning.', 'en', 'US')) = 5))
----

NOTE: `sql` is used when...FIXME
