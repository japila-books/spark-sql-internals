# AvroDataToCatalyst Unary Expression

`AvroDataToCatalyst` is a <<spark-sql-Expression-UnaryExpression.md#, unary expression>> that represents [from_avro](index.md#from_avro) function in a structured query.

[[creating-instance]]
`AvroDataToCatalyst` takes the following when created:

* [[child]] <<expressions/Expression.md#, Catalyst expression>>
* [[jsonFormatSchema]] JSON-encoded Avro schema

`AvroDataToCatalyst` <<doGenCode, generates Java source code (as ExprCode) for code-generated expression evaluation>>.

=== [[doGenCode]] Generating Java Source Code (ExprCode) For Code-Generated Expression Evaluation -- `doGenCode` Method

[source, scala]
----
doGenCode(ctx: CodegenContext, ev: ExprCode): ExprCode
----

NOTE: `doGenCode` is part of <<expressions/Expression.md#doGenCode, Expression Contract>> to generate a Java source code (`ExprCode`) for code-generated expression evaluation.

`doGenCode` requests the `CodegenContext` to [generate code to reference this AvroDataToCatalyst instance](../../whole-stage-code-generation/CodegenContext.md#addReferenceObj).

In the end, `doGenCode` <<spark-sql-Expression-UnaryExpression.md#defineCodeGen, defineCodeGen>> with the function `f` that uses <<nullSafeEval, nullSafeEval>>.

=== [[nullSafeEval]] `nullSafeEval` Method

[source, scala]
----
nullSafeEval(input: Any): Any
----

NOTE: `nullSafeEval` is part of the <<spark-sql-Expression-UnaryExpression.md#nullSafeEval, UnaryExpression Contract>> to...FIXME.

`nullSafeEval`...FIXME
