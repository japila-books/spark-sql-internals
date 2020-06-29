== [[Expression]] Catalyst Expression -- Executable Node in Catalyst Tree

`Expression` is a executable link:spark-sql-catalyst-TreeNode.adoc[node] (in a Catalyst tree) that can <<eval, evaluate>> a result value given input values, i.e. can produce a JVM object per `InternalRow`.

NOTE: `Expression` is often called a *Catalyst expression* even though it is _merely_ built using (not be part of) the link:spark-sql-catalyst.adoc[Catalyst -- Tree Manipulation Framework].

[source, scala]
----
// evaluating an expression
// Use Literal expression to create an expression from a Scala object
import org.apache.spark.sql.catalyst.expressions.Expression
import org.apache.spark.sql.catalyst.expressions.Literal
val e: Expression = Literal("hello")

import org.apache.spark.sql.catalyst.expressions.EmptyRow
val v: Any = e.eval(EmptyRow)

// Convert to Scala's String
import org.apache.spark.unsafe.types.UTF8String
scala> val s = v.asInstanceOf[UTF8String].toString
s: String = hello
----

`Expression` can <<genCode, generate a Java source code>> that is then used in evaluation.

[[deterministic]]
`Expression` is *deterministic* when evaluates to the same result for the same input(s). An expression is deterministic if all the link:spark-sql-catalyst-TreeNode.adoc#children[child expressions] are (which for <<LeafExpression, leaf expressions>> with no child expressions is always true).

NOTE: A deterministic expression is like a https://en.wikipedia.org/wiki/Pure_function[pure function] in functional programming languages.

[source, scala]
----
val e = $"a".expr
scala> :type e
org.apache.spark.sql.catalyst.expressions.Expression

scala> println(e.deterministic)
true
----

NOTE: Non-deterministic expressions are not allowed in some logical operators and are excluded in some optimizations.

[[verboseString]]
`verboseString` is...FIXME

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

* link:spark-sql-Expression-UnixTimestamp.adoc[UnixTimestamp]

| [[CodegenFallback]] link:spark-sql-Expression-CodegenFallback.adoc[CodegenFallback]
| trait
| Does not support code generation and falls back to interpreted mode
a|

* link:spark-sql-Expression-CallMethodViaReflection.adoc[CallMethodViaReflection]

| <<spark-sql-Expression-ExpectsInputTypes.adoc#, ExpectsInputTypes>>
| trait
|
| [[ExpectsInputTypes]]

| [[ExtractValue]] `ExtractValue`
| trait
| Marks `UnresolvedAliases` to be resolved to link:spark-sql-Expression-Alias.adoc[Aliases] with "pretty" SQLs when link:spark-sql-Analyzer-ResolveAliases.adoc#assignAliases[ResolveAliases] is executed
a|

* link:spark-sql-Expression-GetArrayItem.adoc[GetArrayItem]

* link:spark-sql-Expression-GetArrayStructFields.adoc[GetArrayStructFields]

* link:spark-sql-Expression-GetMapValue.adoc[GetMapValue]

* link:spark-sql-Expression-GetStructField.adoc[GetStructField]

| [[LeafExpression]] `LeafExpression`
| abstract class
| Has no link:spark-sql-catalyst-TreeNode.adoc#children[child expressions] (and hence "terminates" the expression tree).
a|

* link:spark-sql-Expression-Attribute.adoc[Attribute]
* link:spark-sql-Expression-Literal.adoc[Literal]

| [[NamedExpression]] link:spark-sql-Expression-NamedExpression.adoc[NamedExpression]
|
| Can later be referenced in a dataflow graph.
|

| [[Nondeterministic]] link:spark-sql-Expression-Nondeterministic.adoc[Nondeterministic]
| trait
|
|

| [[NonSQLExpression]] `NonSQLExpression`
| trait
| Expression with no SQL representation

Gives the only custom <<sql, sql>> method that is non-overridable (i.e. `final`).

When requested <<sql, SQL representation>>, `NonSQLExpression` transforms link:spark-sql-Expression-Attribute.adoc[Attributes] to be ``PrettyAttribute``s to build text representation.
a|

* link:spark-sql-Expression-ScalaUDAF.adoc[ScalaUDAF]
* link:spark-sql-Expression-StaticInvoke.adoc[StaticInvoke]
* link:spark-sql-Expression-TimeWindow.adoc[TimeWindow]

| [[Predicate]] `Predicate`
| trait
| Result link:spark-sql-Expression.adoc#dataType[data type] is always link:spark-sql-DataType.adoc#BooleanType[boolean]
a|
* `And`
* `AtLeastNNonNulls`
* link:spark-sql-Expression-Exists.adoc[Exists]
* link:spark-sql-Expression-In.adoc[In]
* link:spark-sql-Expression-InSet.adoc[InSet]

| [[TernaryExpression]] `TernaryExpression`
| abstract class
|
|

| [[TimeZoneAwareExpression]] `TimeZoneAwareExpression`
| trait
| Timezone-aware expressions
a|

* link:spark-sql-Expression-UnixTimestamp.adoc[UnixTimestamp]
* link:spark-sql-Expression-JsonToStructs.adoc[JsonToStructs]

| [[UnaryExpression]] <<spark-sql-Expression-UnaryExpression.adoc#, UnaryExpression>>
| abstract class
|
a|

* link:spark-sql-Expression-Generator.adoc#ExplodeBase[ExplodeBase]
* link:spark-sql-Expression-Inline.adoc[Inline]
* link:spark-sql-Expression-JsonToStructs.adoc[JsonToStructs]

| `Unevaluable`
| trait
a| [[Unevaluable]] Cannot be evaluated to produce a value (neither in <<spark-sql-Expression.adoc#eval, interpreted>> nor <<spark-sql-Expression.adoc#doGenCode, code-generated>> expression evaluations), i.e. <<eval, eval>> and <<doGenCode, doGenCode>> are not supported and simply report an `UnsupportedOperationException`.

`Unevaluable` expressions have to be resolved (replaced) to some other expressions or logical operators at <<spark-sql-QueryExecution.adoc#analyzed, analysis>> or <<spark-sql-QueryExecution.adoc#optimizedPlan, optimization>> phases or they fail analysis.

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

* link:spark-sql-Expression-AggregateExpression.adoc[AggregateExpression]
* `CurrentDatabase`
* link:spark-sql-Expression-TimeWindow.adoc[TimeWindow]
* link:spark-sql-Expression-UnresolvedFunction.adoc[UnresolvedFunction]
* link:spark-sql-Expression-WindowExpression.adoc[WindowExpression]
* link:spark-sql-Expression-WindowSpecDefinition.adoc[WindowSpecDefinition]
|===

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
| link:spark-sql-DataType.adoc[Data type] of the result of evaluating an expression

| [[doGenCode]] `doGenCode`
| *Code-generated expression evaluation* that generates a Java source code (that is used to evaluate the expression in a more optimized way not directly using <<eval, eval>>).

Used when `Expression` is requested to <<genCode, genCode>>.

| [[eval]] `eval`
a| *Interpreted (non-code-generated) expression evaluation* that evaluates an expression to a JVM object for a given link:spark-sql-InternalRow.adoc[internal binary row] (without <<genCode, generating a corresponding Java code>>.)

NOTE: By default accepts `EmptyRow`, i.e. `null`.

`eval` is a slower "relative" of the <<genCode, code-generated (non-interpreted) expression evaluation>>.

| [[foldable]] `foldable`
|

| [[genCode]] `genCode`
| Generates the Java source code for *code-generated (non-interpreted) expression evaluation* (on an input link:spark-sql-InternalRow.adoc[internal row] in a more optimized way not directly using <<eval, eval>>).

Similar to <<doGenCode, doGenCode>> but supports expression reuse (aka link:spark-sql-subexpression-elimination.adoc[subexpression elimination]).

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

. link:spark-sql-CodegenContext.adoc#INPUT_ROW[INPUT_ROW] of the input `CodegenContext` is defined

. link:spark-sql-CodegenContext.adoc#currentVars[currentVars] of the input `CodegenContext` is not defined

CAUTION: FIXME When would the above not be met? What's so special about such an expression?

`reduceCodeSize` sets the `value` of the input `ExprCode` to the link:spark-sql-CodegenContext.adoc#freshName[fresh term name] for the `value` name.

In the end, `reduceCodeSize` sets the code of the input `ExprCode` to the following:

```
[javaType] [newValue] = [funcFullName]([INPUT_ROW]);
```

The `funcFullName` is the link:spark-sql-CodegenContext.adoc#freshName[fresh term name] for the link:spark-sql-catalyst-TreeNode.adoc#nodeName[name of the current expression node].

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

Internally, `sql` gives a text representation with <<prettyName, prettyName>> followed by `sql` of link:spark-sql-catalyst-TreeNode.adoc#children[children] in the round brackets and concatenated using the comma (`,`).

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
