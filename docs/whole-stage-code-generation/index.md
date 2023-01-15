# Whole-Stage Java Code Generation

**Whole-Stage Java Code Generation** (_Whole-Stage CodeGen_) is a physical query optimization in Spark SQL that fuses multiple physical operators (as a subtree of plans that [support code generation](../physical-operators/CodegenSupport.md)) together into a single Java function.

Whole-Stage Java Code Generation improves the execution performance of a query by collapsing a query tree into a single optimized function that eliminates virtual function calls and leverages CPU registers for intermediate data.

!!! note
    Whole-Stage Code Generation is used by some modern massively parallel processing (MPP) databases to achieve a better query execution performance.

    See [Efficiently Compiling Efficient Query Plans for Modern Hardware (PDF)](http://www.vldb.org/pvldb/vol4/p539-neumann.pdf).

## <span id="ColumnarBatch"> Columnar Execution

The Whole-Stage Code Generation framework is row-based.

The [input RDDs](../physical-operators/CodegenSupport.md#inputRDDs) of the physical operators of a whole-stage pipeline are all `RDD[InternalRow]`s. The output RDD of a whole-stage pipeline is also an `RDD[InternalRow]`. However, the input to a whole-stage code gen stage can be columnar (`RDD[ColumnarBatch]`).

If a physical operator supports [columnar execution](../physical-operators/SparkPlan.md#supportsColumnar), it can't at the same time support whole-stage-codegen.

## <span id="CodegenSupport"> CodegenSupport Physical Operators

Physical operators that support code generation extend [CodegenSupport](../physical-operators/CodegenSupport.md) (and keep [supportCodegen](../physical-operators/CodegenSupport.md#supportCodegen) flag enabled).

## <span id="ObjectType"> ObjectType

Whole-Stage Java Code Generation does not support (_skips_) physical operators that produce a domain object (the [DataType](../expressions/Expression.md#dataType) of the [output expression](../catalyst/QueryPlan.md#output) is [ObjectType](../types/index.md#ObjectType)) as domain objects cannot be written into an [UnsafeRow](../UnsafeRow.md).

## <span id="AggregateCodegenSupport"> AggregateCodegenSupport

For aggregation, Whole-Stage Code Generation is supported by [AggregateCodegenSupport](../physical-operators/AggregateCodegenSupport.md) physical operators ([HashAggregateExec](../physical-operators/HashAggregateExec.md) and [SortAggregateExec](../physical-operators/SortAggregateExec.md)) and only when there are no [ImperativeAggregate](../expressions/ImperativeAggregate.md)s ([supportCodegen](../physical-operators/AggregateCodegenSupport.md#supportCodegen)).

In other words, Whole-Stage Code Generation will only be used for aggreation for [DeclarativeAggregate](../expressions/DeclarativeAggregate.md) and `TypedAggregateExpression` expressions.

## Fast Driver-Local Collect/Take Paths

The following physical operators cannot be a root of [WholeStageCodegen](../physical-operators/WholeStageCodegenExec.md#insertWholeStageCodegen) to support the fast driver-local collect/take paths:

* [LocalTableScanExec](../physical-operators/LocalTableScanExec.md)
* `CommandResultExec`

## <span id="WholeStageCodegenExec"> WholeStageCodegenExec Physical Operator

[WholeStageCodegenExec](../physical-operators/WholeStageCodegenExec.md) physical operator

## <span id="Janino"> Janino

[Janino](https://janino-compiler.github.io/janino/) is used to compile a Java source code into a Java class at runtime.

## Debugging Query Execution

[Debugging Query Execution facility](../debugging-query-execution.md) allows deep dive into the whole-stage code generation.

```scala
val q = spark.range(10).where('id === 4)
```

```text
scala> q.queryExecution.debug.codegen
Found 1 WholeStageCodegen subtrees.
== Subtree 1 / 1 ==
*(1) Filter (id#3L = 4)
+- *(1) Range (0, 10, step=1, splits=8)

Generated code:
/* 001 */ public Object generate(Object[] references) {
/* 002 */   return new GeneratedIteratorForCodegenStage1(references);
/* 003 */ }
/* 004 */
/* 005 */ final class GeneratedIteratorForCodegenStage1 extends org.apache.spark.sql.execution.BufferedRowIterator {
...
```

```text
val q = spark.range(10).where('id === 4)
import org.apache.spark.sql.execution.debug._
scala> q.debugCodegen()
Found 1 WholeStageCodegen subtrees.
== Subtree 1 / 1 ==
*(1) Filter (id#0L = 4)
+- *(1) Range (0, 10, step=1, splits=8)

Generated code:
/* 001 */ public Object generate(Object[] references) {
/* 002 */   return new GeneratedIteratorForCodegenStage1(references);
/* 003 */ }
/* 004 */
/* 005 */ final class GeneratedIteratorForCodegenStage1 extends org.apache.spark.sql.execution.BufferedRowIterator {
...
```

## <span id="CollapseCodegenStages"> CollapseCodegenStages Physical Preparation Rule

At query execution planning, [CollapseCodegenStages](../physical-optimizations/CollapseCodegenStages.md) physical preparation rule finds the physical query plans that support codegen and collapses them together as a [WholeStageCodegen](#WholeStageCodegen) (possibly with [InputAdapter](../physical-operators/InputAdapter.md) in-between for physical operators with no support for Java code generation).

`CollapseCodegenStages` is part of the sequence of physical preparation rules [QueryExecution.preparations](../QueryExecution.md#preparations) that will be applied in order to the physical plan before execution.

## debugCodegen

[debugCodegen](../debugging-query-execution.md#debugCodegen) or [QueryExecution.debug.codegen](../QueryExecution.md#debug) methods allow to access the generated Java source code for a structured query.

As of [Spark 3.0.0](https://issues.apache.org/jira/browse/SPARK-29061), `debugCodegen` prints Java bytecode statistics of generated classes (and compiled by Janino).

```text
import org.apache.spark.sql.execution.debug._
val q = "SELECT sum(v) FROM VALUES(1) t(v)"
scala> sql(q).debugCodegen
Found 2 WholeStageCodegen subtrees.
== Subtree 1 / 2 (maxMethodCodeSize:124; maxConstantPoolSize:130(0.20% used); numInnerClasses:0) ==
...
== Subtree 2 / 2 (maxMethodCodeSize:139; maxConstantPoolSize:137(0.21% used); numInnerClasses:0) ==
```

## spark.sql.codegen.wholeStage

Whole-Stage Code Generation is controlled by [spark.sql.codegen.wholeStage](../configuration-properties.md#spark.sql.codegen.wholeStage) Spark internal property.

Whole-Stage Code Generation is on by default.

```text
assert(spark.sessionState.conf.wholeStageEnabled)
```

## Code Generation Paths

Code generation paths were coined in [this commit](https://github.com/apache/spark/commit/70221903f54eaa0514d5d189dfb6f175a62228a8).

!!! TIP
    Learn more in [SPARK-12795 Whole stage codegen](https://issues.apache.org/jira/browse/SPARK-12795).

### Non-Whole-Stage-Codegen Path

### Produce Path

Whole-stage-codegen "produce" path

A [physical operator](../physical-operators/SparkPlan.md) with [CodegenSupport](../physical-operators/CodegenSupport.md) can [generate Java source code to process the rows from input RDDs](../physical-operators/CodegenSupport.md#doProduce).

### Consume Path

Whole-stage-codegen "consume" path

## BenchmarkWholeStageCodegen

`BenchmarkWholeStageCodegen` class provides a benchmark to measure whole stage codegen performance.

You can execute it using the command:

```text
build/sbt 'sql/testOnly *BenchmarkWholeStageCodegen'
```

!!! NOTE
    You need to un-ignore tests in `BenchmarkWholeStageCodegen` by replacing `ignore` with `test`.

```text
$ build/sbt 'sql/testOnly *BenchmarkWholeStageCodegen'
...
Running benchmark: range/limit/sum
  Running case: range/limit/sum codegen=false
22:55:23.028 WARN org.apache.hadoop.util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
  Running case: range/limit/sum codegen=true

Java HotSpot(TM) 64-Bit Server VM 1.8.0_77-b03 on Mac OS X 10.10.5
Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz

range/limit/sum:                    Best/Avg Time(ms)    Rate(M/s)   Per Row(ns)   Relative
-------------------------------------------------------------------------------------------
range/limit/sum codegen=false             376 /  433       1394.5           0.7       1.0X
range/limit/sum codegen=true              332 /  388       1581.3           0.6       1.1X

[info] - range/limit/sum (10 seconds, 74 milliseconds)
```
