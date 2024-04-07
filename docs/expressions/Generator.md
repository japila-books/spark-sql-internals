---
title: Generator
---

# Generator Expressions

`Generator` is an [extension](#contract) of the [Expression](Expression.md) abstraction for [generator expressions](#implementations) that [can produce multiple rows for a single input row](#eval).

The execution of `Generator` is managed by [GenerateExec](../physical-operators/GenerateExec.md) unary physical operator.

!!! note
    `Generator` corresponds to [LATERAL VIEW](../sql/AstBuilder.md#withGenerate) in SQL.

## Contract (Subset)

### Interpreted Expression Evaluation { #eval }

```scala
eval(
  input: InternalRow): TraversableOnce[InternalRow]
```

Evaluates the given [InternalRow](../InternalRow.md) to produce zero, one or more [InternalRow](../InternalRow.md)s

!!! note "Return Type"
    `eval` is part of the [Expression](Expression.md#eval) abstraction.
    
    This `eval` enforces that `Generator`s produce a collection of [InternalRow](../InternalRow.md)s (not any other value as by non-generator expressions).

## Implementations

* `CollectionGenerator`
* `GeneratorOuter`
* `HiveGenericUDTF`
* `JsonTuple`
* `ReplicateRows`
* `SQLKeywords`
* `Stack`
* `UnevaluableGenerator`
* [UnresolvedGenerator](UnresolvedGenerator.md)
* `UserDefinedGenerator`

## Data Type { #dataType }

??? note "Expression"

    ```scala
    dataType: DataType
    ```

    `dataType` is part of the [Expression](Expression.md#dataType) abstraction.

`dataType` is an [ArrayType](../types/ArrayType.md) of the [elementSchema](#elementSchema).

## supportCodegen { #supportCodegen }

```scala
supportCodegen: Boolean
```

`supportCodegen` is enabled (`true`) when this `Generator` is not [CodegenFallback](../expressions/CodegenFallback.md)

`supportCodegen` is used when:

* `GenerateExec` physical operator is requested for [supportCodegen](../physical-operators/GenerateExec.md#supportCodegen)

<!---
## Review Me

[[terminate]]
`Generator` uses `terminate` to inform that there are no more rows to process, clean up code, and additional rows can be made here.

[source, scala]
----
terminate(): TraversableOnce[InternalRow] = Nil
----

|===
| [[UnresolvedGenerator]] spark-sql-Expression-UnresolvedGenerator.md[UnresolvedGenerator]
a| Represents an unresolved <<Generator, generator>>.

Created when `AstBuilder` sql/AstBuilder.md#withGenerate[creates] `Generate` unary logical operator for `LATERAL VIEW` that corresponds to the following:

```text
LATERAL VIEW (OUTER)?
generatorFunctionName (arg1, arg2, ...)
tblName
AS? col1, col2, ...
```

`UnresolvedGenerator` is [resolved](../Analyzer.md#ResolveFunctions) to `Generator` by [ResolveFunctions](../Analyzer.md#ResolveFunctions) logical evaluation rule.
|===

[[lateral-view]]
[NOTE]
====
You can only have one generator per select clause that is enforced by [ExtractGenerator](../Analyzer.md#ExtractGenerator) logical evaluation rule, e.g.

```text
scala> xys.select(explode($"xs"), explode($"ys")).show
org.apache.spark.sql.AnalysisException: Only one generator allowed per select clause but found 2: explode(xs), explode(ys);
  at org.apache.spark.sql.catalyst.analysis.Analyzer$ExtractGenerator$$anonfun$apply$20.applyOrElse(Analyzer.scala:1670)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$ExtractGenerator$$anonfun$apply$20.applyOrElse(Analyzer.scala:1662)
  at org.apache.spark.sql.catalyst.plans.logical.LogicalPlan$$anonfun$resolveOperators$1.apply(LogicalPlan.scala:62)
```

If you want to have more than one generator in a structured query you should use `LATERAL VIEW` which is supported in SQL only, e.g.

```text
val arrayTuple = (Array(1,2,3), Array("a","b","c"))
val ncs = Seq(arrayTuple).toDF("ns", "cs")

scala> ncs.show
+---------+---------+
|       ns|       cs|
+---------+---------+
|[1, 2, 3]|[a, b, c]|
+---------+---------+

scala> ncs.createOrReplaceTempView("ncs")

val q = """
  SELECT n, c FROM ncs
  LATERAL VIEW explode(ns) nsExpl AS n
  LATERAL VIEW explode(cs) csExpl AS c
"""

scala> sql(q).show
+---+---+
|  n|  c|
+---+---+
|  1|  a|
|  1|  b|
|  1|  c|
|  2|  a|
|  2|  b|
|  2|  c|
|  3|  a|
|  3|  b|
|  3|  c|
+---+---+
```
====
-->
