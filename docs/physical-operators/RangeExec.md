title: RangeExec

# RangeExec Leaf Physical Operator

`RangeExec` is a SparkPlan.md#LeafExecNode[leaf physical operator] that...FIXME

=== [[doProduce]] Generating Java Source Code for Produce Path in Whole-Stage Code Generation -- `doProduce` Method

[source, scala]
----
doProduce(ctx: CodegenContext): String
----

NOTE: `doProduce` is part of <<spark-sql-CodegenSupport.md#doProduce, CodegenSupport Contract>> to generate the Java source code for <<spark-sql-whole-stage-codegen.md#produce-path, produce path>> in Whole-Stage Code Generation.

`doProduce`...FIXME
