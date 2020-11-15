# CodegenFallback &mdash; Catalyst Expressions with Fallback Code Generation Mode

`CodegenFallback` is the <<contract, contract>> of <<implementations, Catalyst expressions>> that do not support a Java code generation and want to <<doGenCode, fall back to interpreted mode>> (aka _fallback mode_).

`CodegenFallback` is used when [CollapseCodegenStages](../physical-optimizations/CollapseCodegenStages.md) physical optimization is executed (and [enforce whole-stage codegen requirements for Catalyst expressions](../physical-optimizations/CollapseCodegenStages.md#supportCodegen-Expression)).

[[contract]]
[source, scala]
----
package org.apache.spark.sql.catalyst.expressions.codegen

trait CodegenFallback extends Expression {
  // No properties (vals and methods) that have no implementation
}
----

[[implementations]]
.(Some Examples of) CodegenFallbacks
[cols="1,2",options="header",width="100%"]
|===
| CodegenFallback
| Description

| `CurrentDate`
| [[CurrentDate]]

| `CurrentTimestamp`
| [[CurrentTimestamp]]

| `Cube`
| [[Cube]]

| <<spark-sql-Expression-JsonToStructs.md#, JsonToStructs>>
| [[JsonToStructs]]

| `Rollup`
| [[Rollup]]

| `StructsToJson`
| [[StructsToJson]]
|===

.Example -- CurrentTimestamp Expression with nullable flag disabled
[source, scala]
----
import org.apache.spark.sql.catalyst.expressions.CurrentTimestamp
val currTimestamp = CurrentTimestamp()

import org.apache.spark.sql.catalyst.expressions.codegen.CodegenFallback
assert(currTimestamp.isInstanceOf[CodegenFallback], "CurrentTimestamp should be a CodegenFallback")

assert(currTimestamp.nullable == false, "CurrentTimestamp should not be nullable")

import org.apache.spark.sql.catalyst.expressions.codegen.{CodegenContext, ExprCode}
val ctx = new CodegenContext
// doGenCode is used when Expression.genCode is executed
val ExprCode(code, _, _) = currTimestamp.genCode(ctx)

scala> println(code)

Object obj_0 = ((Expression) references[0]).eval(null);
        long value_0 = (Long) obj_0;
----

=== [[doGenCode]] Generating Java Source Code (ExprCode) For Code-Generated Expression Evaluation -- `doGenCode` Method

[source, scala]
----
doGenCode(ctx: CodegenContext, ev: ExprCode): ExprCode
----

NOTE: `doGenCode` is part of <<Expression.md#doGenCode, Expression Contract>> to generate a Java source code (ExprCode) for code-generated expression evaluation.

`doGenCode` requests the input `CodegenContext` to add itself to the [references](../whole-stage-code-generation/CodegenContext.md#references).

`doGenCode` [walks down the expression tree](../catalyst/TreeNode.md#foreach) to find <<spark-sql-Expression-Nondeterministic.md#, Nondeterministic>> expressions and for every `Nondeterministic` expression does the following:

. Requests the input `CodegenContext` to add it to the [references](../whole-stage-code-generation/CodegenContext.md#references)

. Requests the input `CodegenContext` to [addPartitionInitializationStatement](../whole-stage-code-generation/CodegenContext.md#addPartitionInitializationStatement) that is a Java code block as follows:
+
[source, scala]
----
((Nondeterministic) references[[childIndex]])
  .initialize(partitionIndex);
----

In the end, `doGenCode` generates a plain Java source code block that is one of the following code blocks per the <<Expression.md#nullable, nullable>> flag. `doGenCode` copies the input `ExprCode` with the code block added (as the `code` property).

.`doGenCode` Code Block for `nullable` flag enabled
[source, scala]
----
[placeHolder]
Object [objectTerm] = ((Expression) references[[idx]]).eval([input]);
boolean [isNull] = [objectTerm] == null;
[javaType] [value] = [defaultValue];
if (![isNull]) {
  [value] = ([boxedType]) [objectTerm];
}
----

.`doGenCode` Code Block for `nullable` flag disabled
[source, scala]
----
[placeHolder]
Object [objectTerm] = ((Expression) references[[idx]]).eval([input]);
[javaType] [value] = ([boxedType]) [objectTerm];
----
