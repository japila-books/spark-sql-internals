# CodegenSupport Physical Operators

`CodegenSupport` is an [extension](#contract) of the [SparkPlan](SparkPlan.md) abstraction for [physical operators](#implementations) that support [Whole-Stage Java Code Generation](../whole-stage-code-generation/index.md).

## Contract

### <span id="doConsume"> Java Source Code for Consume Path

```scala
doConsume(
  ctx: CodegenContext,
  input: Seq[ExprCode],
  row: ExprCode): String
```

Generates a Java source code (as a text) for the physical operator for the ["consume" path](../whole-stage-code-generation/index.md#consume-path) in [Whole-Stage Java Code Generation](../whole-stage-code-generation/index.md)

!!! note "UnsupportedOperationException"
    `doConsume` throws an `UnsupportedOperationException` by default.

Used when the physical operator is requested to [generate the Java source code for consume code path](#consume) (a Java code that consumers the generated columns or a row from a physical operator)

### <span id="doProduce"> Java Source Code for Produce Path

```scala
doProduce(
  ctx: CodegenContext): String
```

Generates a Java source code (as a text) for the physical operator to process the rows from the [input RDDs](#inputRDDs) for the [whole-stage-codegen "produce" path](../whole-stage-code-generation/index.md#produce-path).

Used when the physical operator is requested to [generate the Java source code for "produce" code path](#produce)

### <span id="inputRDDs"> Input RDDs

```scala
inputRDDs(): Seq[RDD[InternalRow]]
```

Input RDDs of the physical operator

!!! important
    [Whole-Stage Java Code Generation](../whole-stage-code-generation/index.md) supports up to two input RDDs.

Used when [WholeStageCodegenExec](WholeStageCodegenExec.md) unary physical operator is executed

## Implementations

* [BroadcastHashJoinExec](BroadcastHashJoinExec.md)
* [ColumnarToRowExec](ColumnarToRowExec.md)
* [DebugExec](DebugExec.md)
* [FilterExec](FilterExec.md)
* [GenerateExec](GenerateExec.md)
* [ProjectExec](ProjectExec.md)
* [RangeExec](RangeExec.md)
* [SerializeFromObjectExec](SerializeFromObjectExec.md)
* [SortMergeJoinExec](SortMergeJoinExec.md)
* [WholeStageCodegenExec](WholeStageCodegenExec.md)
* _others_

## Final Methods

Final methods are used to generate the Java source code in different phases of [Whole-Stage Java Code Generation](../whole-stage-code-generation/index.md).

### <span id="consume"> Generating Java Source Code for Consume Code Path

```scala
consume(
  ctx: CodegenContext,
  outputVars: Seq[ExprCode],
  row: String = null): String
```

`consume` generates Java source code for consuming generated columns or a row from the physical operator

`consume` creates the `ExprCodes` for the input variables (`inputVars`).

* If `outputVars` is defined, `consume` makes sure that their number is exactly the length of the [output attributes](../catalyst/QueryPlan.md#output) and copies them. In other words, `inputVars` is exactly `outputVars`.

* If `outputVars` is not defined, `consume` makes sure that `row` is defined. `consume` sets [currentVars](../whole-stage-code-generation/CodegenContext.md#currentVars) of the `CodegenContext` to `null` while [INPUT_ROW](../whole-stage-code-generation/CodegenContext.md#INPUT_ROW) to the `row`. For every [output attribute](../catalyst/QueryPlan.md#output), `consume` creates a [BoundReference](../expressions/BoundReference.md) and requests it to [generate code for expression evaluation](../expressions/Expression.md#genCode).

`consume` [creates a row variable](#prepareRowVar).

`consume` sets the following in the `CodegenContext`:

* [currentVars](../whole-stage-code-generation/CodegenContext.md#currentVars) as the `inputVars`

* [INPUT_ROW](../whole-stage-code-generation/CodegenContext.md#INPUT_ROW) as `null`

* [freshNamePrefix](../whole-stage-code-generation/CodegenContext.md#freshNamePrefix) as the <<variablePrefix, variablePrefix>> of the <<parent, parent CodegenSupport operator>>.

`consume` <<evaluateRequiredVariables, evaluateRequiredVariables>> (with the `output`, `inputVars` and <<usedInputs, usedInputs>> of the <<parent, parent CodegenSupport operator>>) and creates so-called `evaluated`.

`consume` creates a so-called `consumeFunc` by <<constructDoConsumeFunction, constructDoConsumeFunction>> when the following are all met:

. [spark.sql.codegen.splitConsumeFuncByOperator](../configuration-properties.md#spark.sql.codegen.splitConsumeFuncByOperator) internal configuration property is enabled

. <<usedInputs, usedInputs>> of the <<parent, parent CodegenSupport operator>> contains all catalyst/QueryPlan.md#output[output attributes]

. `paramLength` is correct (FIXME)

Otherwise, `consume` requests the <<parent, parent CodegenSupport operator>> to <<doConsume, doConsume>>.

In the end, `consume` gives the plain Java source code with the comment `CONSUME: [parent]`:

```text
[evaluated]
[consumeFunc]
```

!!! tip
    Enable [spark.sql.codegen.comments](../configuration-properties.md#spark.sql.codegen.comments) Spark SQL property to have `CONSUME` markers in the generated Java source code.

```text
// ./bin/spark-shell --conf spark.sql.codegen.comments=true
import org.apache.spark.sql.execution.debug._
val q = Seq((0 to 4).toList).toDF.
  select(explode('value) as "id").
  join(spark.range(1), "id")
scala> q.debugCodegen
Found 2 WholeStageCodegen subtrees.
...
== Subtree 2 / 2 ==
*Project [id#6]
+- *BroadcastHashJoin [cast(id#6 as bigint)], [id#9L], Inner, BuildRight
   :- Generate explode(value#1), false, false, [id#6]
   :  +- LocalTableScan [value#1]
   +- BroadcastExchange HashedRelationBroadcastMode(List(input[0, bigint, false]))
      +- *Range (0, 1, step=1, splits=8)
...
/* 066 */     while (inputadapter_input.hasNext() && !stopEarly()) {
/* 067 */       InternalRow inputadapter_row = (InternalRow) inputadapter_input.next();
/* 068 */       // CONSUME: BroadcastHashJoin [cast(id#6 as bigint)], [id#9L], Inner, BuildRight
/* 069 */       // input[0, int, false]
/* 070 */       int inputadapter_value = inputadapter_row.getInt(0);
...
/* 079 */       // find matches from HashedRelation
/* 080 */       UnsafeRow bhj_matched = bhj_isNull ? null: (UnsafeRow)bhj_relation.getValue(bhj_value);
/* 081 */       if (bhj_matched != null) {
/* 082 */         {
/* 083 */           bhj_numOutputRows.add(1);
/* 084 */
/* 085 */           // CONSUME: Project [id#6]
/* 086 */           // CONSUME: WholeStageCodegen
/* 087 */           project_rowWriter.write(0, inputadapter_value);
/* 088 */           append(project_result);
/* 089 */
/* 090 */         }
/* 091 */       }
/* 092 */       if (shouldStop()) return;
...
```

`consume` is used when:

* [BroadcastHashJoinExec](BroadcastHashJoinExec.md#doConsume), `BaseLimitExec`, [DeserializeToObjectExec](DeserializeToObjectExec.md#doConsume), `ExpandExec`, <<FilterExec.md#doConsume, FilterExec>>, GenerateExec.md#doConsume[GenerateExec], ProjectExec.md#doConsume[ProjectExec], `SampleExec`, `SerializeFromObjectExec`, `MapElementsExec`, `DebugExec` physical operators are requested to generate the Java source code for ["consume" path](../whole-stage-code-generation/index.md#consume-path) in whole-stage code generation

* [ColumnarBatchScan](ColumnarBatchScan.md#doProduce), [HashAggregateExec](HashAggregateExec.md#doProduce), [InputAdapter](InputAdapter.md#doProduce), [RowDataSourceScanExec](RowDataSourceScanExec.md#doProduce), [RangeExec](RangeExec.md#doProduce), [SortExec](SortExec.md#doProduce), [SortMergeJoinExec](SortMergeJoinExec.md#doProduce) physical operators are requested to generate the Java source code for the ["produce" path](../whole-stage-code-generation/index.md#produce-path) in whole-stage code generation

### <span id="limitNotReachedCond"> Data-Producing Loop Condition

```scala
limitNotReachedCond: String
```

`limitNotReachedCond` is used as a loop condition by [ColumnarToRowExec](ColumnarToRowExec.md), [SortExec](SortExec.md), `InputRDDCodegen` and [HashAggregateExec](HashAggregateExec.md) physical operators (when requested to [doProduce](#doProduce)).

`limitNotReachedCond` requests the [parent](#parent) physical operator for the [limit-not-reached checks](#limitNotReachedChecks).

`limitNotReachedCond` returns an empty string for no [limit-not-reached checks](#limitNotReachedChecks) or concatenates them with `&&`.

### <span id="produce"> Generating Java Source Code for Produce Code Path

```scala
produce(
  ctx: CodegenContext,
  parent: CodegenSupport): String
```

`produce` generates Java source code for [whole-stage-codegen "produce" code path](../whole-stage-code-generation/index.md#produce-path).

`produce` [prepares a physical operator for query execution](SparkPlan.md#executeQuery) and then generates a Java source code with the result of [doProduce](#doProduce).

`produce` annotates the code block with `PRODUCE` markers (that are [simple descriptions](../catalyst/QueryPlan.md#simpleString) of the physical operators in a structured query).

`produce` is used when:

* (most importantly) `WholeStageCodegenExec` physical operator is requested to [generate the Java source code for a subtree](WholeStageCodegenExec.md#doCodeGen)

* A physical operator (with `CodegenSupport`) is requested to [generate a Java source code for the produce path in whole-stage Java code generation](#doProduce) that usually looks as follows:

    ```scala
    protected override def doProduce(ctx: CodegenContext): String = {
      child.asInstanceOf[CodegenSupport].produce(ctx, this)
    }
    ```

!!! tip "spark.sql.codegen.comments Property"
    Enable `spark.sql.codegen.comments` Spark SQL property for `PRODUCE` markers in the generated Java source code.

```text
// ./bin/spark-shell --conf spark.sql.codegen.comments=true
import org.apache.spark.sql.execution.debug._
val q = Seq((0 to 4).toList).toDF.
  select(explode('value) as "id").
  join(spark.range(1), "id")
scala> q.debugCodegen
Found 2 WholeStageCodegen subtrees.
== Subtree 1 / 2 ==
*Range (0, 1, step=1, splits=8)
...
/* 080 */   protected void processNext() throws java.io.IOException {
/* 081 */     // PRODUCE: Range (0, 1, step=1, splits=8)
/* 082 */     // initialize Range
/* 083 */     if (!range_initRange) {
...
== Subtree 2 / 2 ==
*Project [id#6]
+- *BroadcastHashJoin [cast(id#6 as bigint)], [id#9L], Inner, BuildRight
   :- Generate explode(value#1), false, false, [id#6]
   :  +- LocalTableScan [value#1]
   +- BroadcastExchange HashedRelationBroadcastMode(List(input[0, bigint, false]))
      +- *Range (0, 1, step=1, splits=8)
...
/* 062 */   protected void processNext() throws java.io.IOException {
/* 063 */     // PRODUCE: Project [id#6]
/* 064 */     // PRODUCE: BroadcastHashJoin [cast(id#6 as bigint)], [id#9L], Inner, BuildRight
/* 065 */     // PRODUCE: InputAdapter
/* 066 */     while (inputadapter_input.hasNext() && !stopEarly()) {
...
```

## <span id="supportCodegen"> supportCodegen Flag

```scala
supportCodegen: Boolean
```

`supportCodegen` allows physical operators to disable Java code generation.

`supportCodegen` flag is to select between `InputAdapter` or `WholeStageCodegenExec` physical operators when [CollapseCodegenStages](../physical-optimizations/CollapseCodegenStages.md) physical optimization is executed (and [checks whether a physical operator meets the requirements of whole-stage Java code generation or not](../physical-optimizations/CollapseCodegenStages.md#supportCodegen)).

`supportCodegen` flag is turned on by default.

!!! note
    `supportCodegen` is turned off in the following physical operators:

    * [GenerateExec](GenerateExec.md)
    * [HashAggregateExec](HashAggregateExec.md) with [ImperativeAggregate](../expressions/ImperativeAggregate.md) expressions
    * [SortMergeJoinExec](SortMergeJoinExec.md) for all [join types](../joins.md#join-types) except `INNER` and `CROSS`

## <span id="prepareRowVar"> prepareRowVar Internal Method

```scala
prepareRowVar(
  ctx: CodegenContext,
  row: String,
  colVars: Seq[ExprCode]): ExprCode
```

`prepareRowVar`...FIXME

`prepareRowVar` is used when `CodegenSupport` is requested to [consume](#consume) (and [constructDoConsumeFunction](#constructDoConsumeFunction) with [spark.sql.codegen.splitConsumeFuncByOperator](../configuration-properties.md#spark.sql.codegen.splitConsumeFuncByOperator) enabled).

## <span id="constructDoConsumeFunction"> constructDoConsumeFunction Internal Method

```scala
constructDoConsumeFunction(
  ctx: CodegenContext,
  inputVars: Seq[ExprCode],
  row: String): String
```

`constructDoConsumeFunction`...FIXME

`constructDoConsumeFunction` is used when `CodegenSupport` is requested to [consume](#consume).

## <span id="usedInputs"> usedInputs Method

```scala
usedInputs: AttributeSet
```

`usedInputs` returns the [expression references](../catalyst/QueryPlan.md#references).

!!! note
    Physical operators can mark it as empty to defer evaluation of attribute expressions until they are actually used (in the [generated Java source code for consume path](#consume)).

`usedInputs` is used when `CodegenSupport` is requested to [generate a Java source code for consume path](#consume).

## <span id="parent"> parent Internal Variable Property

```scala
parent: CodegenSupport
```

`parent` is a physical operator that supports whole-stage Java code generation.

`parent` starts empty, (defaults to `null` value) and is assigned a physical operator (with `CodegenContext`) only when `CodegenContext` is requested to [generate a Java source code for produce code path](#produce). The physical operator is passed in as an input argument for the [produce](#produce) code path.

## <span id="limitNotReachedChecks"> limitNotReachedChecks Method

```scala
limitNotReachedChecks: Seq[String]
```

`limitNotReachedChecks` is a sequence of checks which evaluate to true if the downstream Limit operators have not received enough records and reached the limit.

`limitNotReachedChecks` requests the [parent](#parent) physical operator for `limitNotReachedChecks`.

`limitNotReachedChecks` is used when:

* `RangeExec` physical operator is requested to [doProduce](RangeExec.md#doProduce)
* `BaseLimitExec` physical operator is requested to `limitNotReachedChecks`
* `CodegenSupport` physical operator is requested to [limitNotReachedCond](#limitNotReachedCond)

## <span id="canCheckLimitNotReached"> canCheckLimitNotReached Method

```scala
canCheckLimitNotReached: Boolean
```

`canCheckLimitNotReached`...FIXME

`canCheckLimitNotReached` is used when `CodegenSupport` physical operator is requested to [limitNotReachedCond](#limitNotReachedCond).

## <span id="variablePrefix"> Variable Name Prefix

```scala
variablePrefix: String
```

`variablePrefix` is the prefix of the variable names of this physical operator.

Physical Operator | Prefix
------------------|----------
 [HashAggregateExec](HashAggregateExec.md) | agg
 [BroadcastHashJoinExec](BroadcastHashJoinExec.md) | bhj
 [ShuffledHashJoinExec](ShuffledHashJoinExec.md) | shj
 [SortMergeJoinExec](SortMergeJoinExec.md) | smj
 RDDScanExec | rdd
 [DataSourceScanExec](DataSourceScanExec.md) | scan
 [InMemoryTableScanExec](InMemoryTableScanExec.md) | memoryScan
 [WholeStageCodegenExec](WholeStageCodegenExec.md) | wholestagecodegen
 _others_ | Lower-case [node name](../catalyst/TreeNode.md#nodeName)

`variablePrefix` is used when:

* `CodegenSupport` is requested to generate the Java source code for [produce](#produce) and [consume](#consume) code paths

## <span id="needCopyResult"> needCopyResult Flag

```scala
needCopyResult: Boolean
```

`needCopyResult` controls whether `WholeStageCodegenExec` physical operator should copy result when requested for the [Java source code for consume path](WholeStageCodegenExec.md#doConsume).

`needCopyResult`...FIXME

## Demo

```text
val q = spark.range(1)

import org.apache.spark.sql.execution.debug._
scala> q.debugCodegen
Found 1 WholeStageCodegen subtrees.
== Subtree 1 / 1 ==
*Range (0, 1, step=1, splits=8)

Generated code:
...

// The above is equivalent to the following method chain
scala> q.queryExecution.debug.codegen
Found 1 WholeStageCodegen subtrees.
== Subtree 1 / 1 ==
*Range (0, 1, step=1, splits=8)

Generated code:
...
```
