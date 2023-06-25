# AggregateCodegenSupport Physical Operators

`AggregateCodegenSupport` is an [extension](#contract) of the [BaseAggregateExec](BaseAggregateExec.md) abstraction for [aggregate physical operators](#implementations) that support [Whole-Stage Java Code Generation](../whole-stage-code-generation/index.md) (with [produce](#doProduce) and [consume](#doConsume) code execution paths).

`AggregateCodegenSupport` is a `BlockingOperatorWithCodegen`.

## Contract

### <span id="doConsumeWithKeys"> doConsumeWithKeys

```scala
doConsumeWithKeys(
  ctx: CodegenContext,
  input: Seq[ExprCode]): String
```

See:

* [HashAggregateExec](HashAggregateExec.md#doConsumeWithKeys)
* [SortAggregateExec](SortAggregateExec.md#doConsumeWithKeys)

Used when:

* `AggregateCodegenSupport` is requested to [doConsume](#doConsume)

### doProduceWithKeys { #doProduceWithKeys }

```scala
doProduceWithKeys(
  ctx: CodegenContext): String
```

See:

* [HashAggregateExec](HashAggregateExec.md#doProduceWithKeys)
* [SortAggregateExec](SortAggregateExec.md#doProduceWithKeys)

Used when:

* `AggregateCodegenSupport` is requested to [doProduce](#doProduce) (with [grouping keys](BaseAggregateExec.md#groupingExpressions) specified)

### needHashTable { #needHashTable }

```scala
needHashTable: Boolean
```

Whether this aggregate operator needs to build a hash table

| Aggregate Physical Operator | needHashTable |
| :-------------------------: | :--------------: |
| [HashAggregateExec](HashAggregateExec.md) | [:white_check_mark:](HashAggregateExec.md#needHashTable) |
| [SortAggregateExec](SortAggregateExec.md) | [❌](HashAggregateExec.md#needHashTable) |

Used when:

* `AggregateCodegenSupport` is requested to [doProduceWithoutKeys](#doProduceWithoutKeys)

## Implementations

* [HashAggregateExec](HashAggregateExec.md)
* [SortAggregateExec](SortAggregateExec.md)

## supportCodegen { #supportCodegen }

??? note "CodegenSupport"

    ```scala
    supportCodegen: Boolean
    ```

    `supportCodegen` is part of the [CodegenSupport](CodegenSupport.md#supportCodegen) abstraction.

`supportCodegen` is enabled (`true`) when all the following hold:

* All [aggregate buffer attributes](#aggregateBufferAttributes) are [mutable](../UnsafeRow.md#isMutable)
* No [ImperativeAggregate](../expressions/ImperativeAggregate.md)s among the [AggregateFunction](../expressions/AggregateExpression.md#aggregateFunction)s (of the [AggregateExpressions](BaseAggregateExec.md#aggregateExpressions))

!!! note "SortAggregateExec"
    `SortAggregateExec` physical operator can change [supportCodegen](SortAggregateExec.md#supportCodegen).

## Generating Java Source Code for Produce Path { #doProduce }

??? note "CodegenSupport"

    ```scala
    doProduce(
      ctx: CodegenContext): String
    ```

    `doProduce` is part of the [CodegenSupport](CodegenSupport.md#doProduce) abstraction.

With no [grouping keys](BaseAggregateExec.md#groupingExpressions), `doProduce` [doProduceWithoutKeys](#doProduceWithoutKeys). Otherwise, `doProduce` [doProduceWithKeys](#doProduceWithKeys).

### doProduceWithoutKeys { #doProduceWithoutKeys }

```scala
doProduceWithoutKeys(
  ctx: CodegenContext): String
```

`doProduceWithoutKeys` takes the [DeclarativeAggregate](../expressions/DeclarativeAggregate.md)s of the [AggregateExpressions](BaseAggregateExec.md#aggregateExpressions) for the [expressions to initialize empty aggregation buffers](../expressions/DeclarativeAggregate.md#initialValues).

`doProduceWithoutKeys`...FIXME

#### Demo

Not only does the following query uses no groping keys, but also no aggregate functions.

```scala
val q = spark.range(4).groupBy().agg(lit(1))
```

```text
scala> q.explain
warning: 1 deprecation (since 2.13.3); for details, enable `:setting -deprecation` or `:replay -deprecation`
== Physical Plan ==
AdaptiveSparkPlan isFinalPlan=false
+- HashAggregate(keys=[], functions=[])
   +- Exchange SinglePartition, ENSURE_REQUIREMENTS, [plan_id=174]
      +- HashAggregate(keys=[], functions=[])
         +- Project
            +- Range (0, 4, step=1, splits=16)
```

```scala
import org.apache.spark.sql.execution.adaptive.AdaptiveSparkPlanExec
val aqe = q.queryExecution.executedPlan.collectFirst { case asp: AdaptiveSparkPlanExec => asp }.get
```

```scala
assert(aqe.isFinalPlan == false)
```

```scala
aqe.execute()
```

```scala
assert(aqe.isFinalPlan == true)
```

```text
scala> println(q.queryExecution.explainString(mode = org.apache.spark.sql.execution.CodegenMode))
Found 2 WholeStageCodegen subtrees.
== Subtree 1 / 2 (maxMethodCodeSize:282; maxConstantPoolSize:193(0.29% used); numInnerClasses:0) ==
*(1) HashAggregate(keys=[], functions=[], output=[])
+- *(1) Project
   +- *(1) Range (0, 4, step=1, splits=16)

Generated code:
/* 001 */ public Object generate(Object[] references) {
/* 002 */   return new GeneratedIteratorForCodegenStage1(references);
/* 003 */ }
/* 004 */
/* 005 */ // codegenStageId=1
/* 006 */ final class GeneratedIteratorForCodegenStage1 extends org.apache.spark.sql.execution.BufferedRowIterator {
/* 007 */   private Object[] references;
/* 008 */   private scala.collection.Iterator[] inputs;
/* 009 */   private boolean hashAgg_initAgg_0;
/* 010 */   private boolean range_initRange_0;
/* 011 */   private long range_nextIndex_0;
/* 012 */   private TaskContext range_taskContext_0;
/* 013 */   private InputMetrics range_inputMetrics_0;
/* 014 */   private long range_batchEnd_0;
/* 015 */   private long range_numElementsTodo_0;
/* 016 */   private org.apache.spark.sql.catalyst.expressions.codegen.UnsafeRowWriter[] range_mutableStateArray_0 = new org.apache.spark.sql.catalyst.expressions.codegen.UnsafeRowWriter[1];
...
```

## Generating Java Source Code for Consume Path { #doConsume }

??? note "CodegenSupport"

    ```scala
    doConsume(
      ctx: CodegenContext,
      input: Seq[ExprCode],
      row: ExprCode): String
    ```

    `doConsume` is part of the [CodegenSupport](CodegenSupport.md#doConsume) abstraction.

With no [grouping keys](BaseAggregateExec.md#groupingExpressions), `doConsume` [doConsumeWithoutKeys](#doConsumeWithoutKeys). Otherwise, `doConsume` [doConsumeWithKeys](#doConsumeWithKeys).

### doConsumeWithoutKeys { #doConsumeWithoutKeys }

```scala
doConsumeWithoutKeys(
  ctx: CodegenContext,
  input: Seq[ExprCode]): String
```

`doConsumeWithoutKeys`...FIXME
