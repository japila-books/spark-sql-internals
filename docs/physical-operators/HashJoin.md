# HashJoin &mdash; Hash-Based Join Physical Operators

`HashJoin` is an [extension](#contract) of the [JoinCodegenSupport](JoinCodegenSupport.md) abstraction for [hash-based join physical operators](#implementations) with support for [Java code generation](CodegenSupport.md).

## Contract

### <span id="buildSide"> BuildSide

```scala
buildSide: BuildSide
```

### <span id="prepareRelation"> Preparing HashedRelation

```scala
prepareRelation(
  ctx: CodegenContext): HashedRelationInfo
```

Used when:

* `HashJoin` is requested to [codegenInner](#codegenInner), [codegenOuter](#codegenOuter), [codegenSemi](#codegenSemi), [codegenAnti](#codegenAnti), [codegenExistence](#codegenExistence)

## Implementations

* [BroadcastHashJoinExec](BroadcastHashJoinExec.md)
* [ShuffledHashJoinExec](ShuffledHashJoinExec.md)

## <span id="buildKeys"> Build Keys

```scala
buildKeys: Seq[Attribute]
```

??? note "Lazy Value"
    `buildKeys` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`buildKeys` is the [left keys](BaseJoinExec.md#leftKeys) for the [BuildSide](#buildSide) as `BuildLeft` while the [right keys](BaseJoinExec.md#rightKeys) as `BuildRight`.

!!! important
    `HashJoin` assumes that the number of the [left](BaseJoinExec.md#leftKeys) and the [right](BaseJoinExec.md#rightKeys) keys are the same and are of the same types (position-wise).

## <span id="streamedKeys"> Streamed Keys

```scala
streamedKeys: Seq[Attribute]
```

??? note "Lazy Value"
    `streamedKeys` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`streamedKeys` is the opposite of the [build keys](#buildKeys).

`streamedKeys` is the [right keys](BaseJoinExec.md#rightKeys) for the [BuildSide](#buildSide) as `BuildLeft` while the [left keys](BaseJoinExec.md#leftKeys) as `BuildRight`.

## <span id="output"> Output Attributes

```scala
output: Seq[Attribute]
```

`output` is a collection of [Attribute](../expressions/Attribute.md)s based on the [joinType](BaseJoinExec.md#joinType).

joinType | Output Schema
---------|--------------
 `InnerLike` | [output](../catalyst/QueryPlan.md#output) of the [left](#left) followed by the [right](#right) operator's
 `LeftOuter` | [output](../catalyst/QueryPlan.md#output) of the [left](#left) followed by the [right](#right) operator's (with `nullability` on)
 `RightOuter` | [output](../catalyst/QueryPlan.md#output) of the [left](#left) (with `nullability` on) followed by the [right](#right) operator's
 `ExistenceJoin` | [output](../catalyst/QueryPlan.md#output) of the [left](#left) followed by the `exists` attribute
 `LeftSemi` | [output](../catalyst/QueryPlan.md#output) of the [left](#left) operator
 `LeftAnti` | [output](../catalyst/QueryPlan.md#output) of the [left](#left) operator

`output` is part of the [QueryPlan](../catalyst/QueryPlan.md#output) abstraction.

## <span id="CodegenSupport"> CodegenSupport

`HashJoin` is a [CodegenSupport](CodegenSupport.md) (indirectly as a [JoinCodegenSupport](JoinCodegenSupport.md)).

### <span id="doConsume"> Consume Path

```scala
doConsume(
  ctx: CodegenContext,
  input: Seq[ExprCode],
  row: ExprCode): String
```

`doConsume` generates a Java source code for "consume" path based on the [joinType](BaseJoinExec.md#joinType).

joinType | doConsume
---------|--------------
 `InnerLike` | [codegenInner](#codegenInner)
 `LeftOuter` | [codegenOuter](#codegenOuter)
 `RightOuter` | [codegenOuter](#codegenOuter)
 `LeftSemi` | [codegenSemi](#codegenSemi)
 `LeftAnti` | [codegenAnti](#codegenAnti)
 `ExistenceJoin` | [codegenExistence](#codegenExistence)

`doConsume` is part of the [CodegenSupport](CodegenSupport.md#doConsume) abstraction.

### <span id="doProduce"> Produce Path

```scala
doProduce(
  ctx: CodegenContext): String
```

`doProduce` assumes that the [streamedPlan](#streamedPlan) is a [CodegenSupport](CodegenSupport.md) and requests it to [generate a Java source code for "produce" path](CodegenSupport.md#doProduce).

`doProduce` is part of the [CodegenSupport](CodegenSupport.md#doProduce) abstraction.

## <span id="join"> join

```scala
join(
  streamedIter: Iterator[InternalRow],
  hashed: HashedRelation,
  numOutputRows: SQLMetric): Iterator[InternalRow]
```

`join` branches off per [JoinType](BaseJoinExec.md#joinType) to create an joined rows iterator (off the rows from the input `streamedIter` and `hashed`):

* [innerJoin](#innerJoin) for a [InnerLike](../joins.md#InnerLike) join

* [outerJoin](#outerJoin) for a [LeftOuter](../joins.md#LeftOuter) or a [RightOuter](../joins.md#RightOuter) join

* [semiJoin](#semiJoin) for a [LeftSemi](../joins.md#LeftSemi) join

* [antiJoin](#antiJoin) for a [LeftAnti](../joins.md#LeftAnti) join

* [existenceJoin](#existenceJoin) for a [ExistenceJoin](../joins.md#ExistenceJoin) join

`join` [creates a result projection](#createResultProjection).

In the end, for every row in the joined rows iterator `join` increments the input `numOutputRows` SQL metric and applies the result projection.

`join` reports an `IllegalArgumentException` for unsupported [JoinType](BaseJoinExec.md#joinType):

```text
HashJoin should not take [joinType] as the JoinType
```

`join` is used when:

* [BroadcastHashJoinExec](BroadcastHashJoinExec.md) and [ShuffledHashJoinExec](ShuffledHashJoinExec.md) physical operators are executed

## Generating Java Code

### <span id="codegenInner"> Inner Join

```scala
codegenInner(
  ctx: CodegenContext,
  input: Seq[ExprCode]): String
```

`codegenInner` [prepares a HashedRelation](#prepareRelation) (with the given [CodegenContext](../whole-stage-code-generation/CodegenContext.md)).

!!! note
    [Preparing a HashedRelation](#prepareRelation) is implementation-specific.

`codegenInner` [genStreamSideJoinKey](#genStreamSideJoinKey) and [getJoinCondition](#getJoinCondition).

For `isEmptyHashedRelation`, `codegenInner` returns the following text (which is simply a comment with no executable code):

```text
// If HashedRelation is empty, hash inner join simply returns nothing.
```

For `keyIsUnique`, `codegenInner` returns the following code:

```text
// generate join key for stream side
[keyEv.code]
// find matches from HashedRelation
UnsafeRow [matched] = [anyNull] ? null: (UnsafeRow)[relationTerm].getValue([keyEv.value]);
if ([matched] != null) {
  [checkCondition] {
    [numOutput].add(1);
    [consume(ctx, resultVars)]
  }
}
```

For all other cases, `codegenInner` returns the following code:

```text
// generate join key for stream side
[keyEv.code]
// find matches from HashRelation
Iterator[UnsafeRow] [matches] = [anyNull] ?
  null : (Iterator[UnsafeRow])[relationTerm].get([keyEv.value]);
if ([matches] != null) {
  while ([matches].hasNext()) {
    UnsafeRow [matched] = (UnsafeRow) [matches].next();
    [checkCondition] {
      [numOutput].add(1);
      [consume(ctx, resultVars)]
    }
  }
}
```

`codegenInner` is used when:

* `HashJoin` is requested to [doConsume](#doConsume) (for `INNER` or `CROSS` joins)

### <span id="codegenAnti"> Anti Join

```scala
codegenAnti(
  ctx: CodegenContext,
  input: Seq[ExprCode]): String
```

`codegenAnti`...FIXME

`codegenAnti` is used when:

* `BroadcastHashJoinExec` physical operator is requested to [codegenAnti](BroadcastHashJoinExec.md#codegenAnti) (with the [isNullAwareAntiJoin](BroadcastHashJoinExec.md#isNullAwareAntiJoin) flag off)
* `HashJoin` is requested to [doConsume](#doConsume)
