# MonotonicallyIncreasingID

`MonotonicallyIncreasingID` is a [non-deterministic](Nondeterministic.md) [leaf expression](Expression.md#LeafExpression) that represents `monotonically_increasing_id` [standard](../spark-sql-functions.md#monotonically_increasing_id) and [SQL](../FunctionRegistry.md#monotonically_increasing_id) functions in [logical query plans](../logical-operators/LogicalPlan.md).

## <span id="dataType"> DataType

```scala
dataType: DataType
```

`dataType` is always [LongType](../types/DataType.md#LongType)

`dataType` is part of the [Expression](Expression.md#dataType) abstraction.

## <span id="nullable"> Never Nullable

```scala
nullable: Boolean
```

`nullable` is always `false`.

`nullable` is part of the [Expression](Expression.md#nullable) abstraction.

## <span id="initializeInternal"> Initialization

```scala
initializeInternal(
  partitionIndex: Int): Unit
```

`initializeInternal` initializes the following internal registries:

* [count](#count) to `0`
* [partitionMask](#partitionMask) as `partitionIndex.toLong << 33`

```text
val partitionIndex = 1
val partitionMask = partitionIndex.toLong << 33
scala> println(partitionMask.toBinaryString)
1000000000000000000000000000000000
```

`initializeInternal` is part of the [Nondeterministic](Nondeterministic.md#initializeInternal) abstraction.

## <span id="evalInternal"> Interpreted Expression Evaluation

```scala
evalInternal(
  input: InternalRow): Long
```

`evalInternal` increments the [count](#count) internal counter.

`evalInternal` increments the [partitionMask](#partitionMask) internal registry by the previous [count](#count).

`evalInternal` is part of the [Nondeterministic](Nondeterministic.md#evalInternal) abstraction.

## <span id="doGenCode"> Code-Generated Expression Evaluation

```scala
doGenCode(
  ctx: CodegenContext,
  ev: ExprCode): ExprCode
```

`doGenCode` is part of the [Expression](Expression.md#doGenCode) abstraction.

---

`doGenCode` requests the `CodegenContext` to [add a mutable state](../whole-stage-code-generation/CodegenContext.md#addMutableState) as `count` name and `long` Java type.

`doGenCode` requests the `CodegenContext` to [add an immutable state (unless exists already)](../whole-stage-code-generation/CodegenContext.md#addImmutableStateIfNotExists) as `partitionMask` name and `long` Java type.

`doGenCode` requests the `CodegenContext` to [addPartitionInitializationStatement](../whole-stage-code-generation/CodegenContext.md#addPartitionInitializationStatement) with `[countTerm] = 0L;` statement.

`doGenCode` requests the `CodegenContext` to [addPartitionInitializationStatement](../whole-stage-code-generation/CodegenContext.md#addPartitionInitializationStatement) with `[partitionMaskTerm] = ((long) partitionIndex) << 33;` statement.

In the end, `doGenCode` returns the input `ExprCode` with the `code` as follows and `isNull` property disabled (`false`):

```text
final [dataType] [value] = [partitionMaskTerm] + [countTerm];
      [countTerm]++;
```

---

```scala
import org.apache.spark.sql.catalyst.expressions.MonotonicallyIncreasingID
val monotonicallyIncreasingID = MonotonicallyIncreasingID()

// doGenCode is used when Expression.genCode is executed

import org.apache.spark.sql.catalyst.expressions.codegen.CodegenContext
val ctx = new CodegenContext
val code = monotonicallyIncreasingID.genCode(ctx).code
```

```text
scala> println(code)
final long value_0 = partitionMask + count_0;
      count_0++;
```

## <span id="Stateful"> Stateful

`MonotonicallyIncreasingID` is a [Stateful](Stateful.md).
