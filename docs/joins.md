# Join Queries

From PostgreSQL's [2.6. Joins Between Tables](https://www.postgresql.org/docs/current/static/tutorial-join.html):

> Queries can access multiple tables at once, or access the same table in such a way that multiple rows of the table are being processed at the same time. A query that accesses multiple rows of the same or different tables at one time is called a **join query**.

## Dataset Join Operators

Operator | Return Type | Description
---------|----------|---------
 [crossJoin](#crossJoin) | [DataFrame](DataFrame.md) | Untyped ``Row``-based cross join
 [join](#join) | [DataFrame](DataFrame.md) | Untyped ``Row``-based join
 [joinWith](#joinWith) | [Dataset](Dataset.md) | Type-preserving join with two output columns for records for which a join condition holds

`join` operators create a `DataFrame` with a [Join](logical-operators/Join.md) logical operator.

### <span id="crossJoin"> crossJoin

```scala
crossJoin(
  right: Dataset[_]): DataFrame
```

`crossJoin` creates a [Join](logical-operators/Join.md) logical operator with the [Cross](#JoinType) join type.

### <span id="join"> join

```scala
join(
  right: Dataset[_]): DataFrame
join(
  right: Dataset[_],
  joinExprs: Column): DataFrame
join(
  right: Dataset[_],
  joinExprs: Column,
  joinType: String): DataFrame
join(
  right: Dataset[_],
  usingColumns: Seq[String]): DataFrame
join(
  right: Dataset[_],
  usingColumns: Seq[String],
  joinType: String): DataFrame
join(
  right: Dataset[_],
  usingColumn: String): DataFrame
```

`join` creates a [Join](logical-operators/Join.md) logical operator with the given join type or the [Inner](#JoinType).

### <span id="joinWith"> joinWith

```scala
joinWith[U](
  other: Dataset[U],
  condition: Column): Dataset[(T, U)]
joinWith[U](
  other: Dataset[U],
  condition: Column,
  joinType: String): Dataset[(T, U)]
```

`joinWith` creates a [Join](logical-operators/Join.md) logical operator with the given join type or the [Inner](#JoinType).

## Query Execution Planning

[JoinSelection](execution-planning-strategies/JoinSelection.md) execution planning strategy is used to plan [Join](logical-operators/Join.md) logical operators.

## Join Condition

Join condition (_join expression_) can be specified using the [join operators](#dataset-join-operators), [where](dataset-operators.md#where) or [filter](dataset-operators.md#filter) operators.

```scala
df1.join(df2, $"df1Key" === $"df2Key")
df1.join(df2).where($"df1Key" === $"df2Key")
df1.join(df2).filter($"df1Key" === $"df2Key")
```

## <span id="joinType" /><span id="JoinType" /><span id="join-types" /><span id="Cross" /><span id="Inner" /><span id="FullOuter" /><span id="LeftAnti" /><span id="LeftOuter" /><span id="LeftSemi" /><span id="RightOuter" /><span id="NaturalJoin" /><span id="UsingJoin" /> Join Types

Join types can be specified using the [join operators](#dataset-join-operators) (using `joinType` optional parameter).

```scala
df1.join(df2, $"df1Key" === $"df2Key", "inner")
```

Join names are case-insensitive and can use the underscore (`_`) at any position (e.g. `left_anti` and `L_E_F_T_A_N_T_I` are equivalent).

SQL          | JoinType    | Parameter Name
-------------|-------------|---------
 CROSS       | Cross       | cross
 INNER       | Inner       | inner
 FULL OUTER  | FullOuter   | outer, full, fullouter
 LEFT ANTI   | LeftAnti    | leftanti
 LEFT OUTER  | LeftOuter   | leftouter, left
 LEFT SEMI   | LeftSemi    | leftsemi
 RIGHT OUTER | RightOuter  | rightouter, right
 NATURAL     | NaturalJoin | Special case for Inner, LeftOuter, RightOuter, FullOuter
 USING       | UsingJoin   | Special case for Inner, LeftOuter, LeftSemi, RightOuter, FullOuter, LeftAnti

## <span id="ExistenceJoin"> ExistenceJoin

`ExistenceJoin` is an artifical join type used to express an existential sub-query, that is often referred to as **existential join**.

[LeftAnti](#LeftAnti) and [ExistenceJoin](#ExistenceJoin) are special cases of [LeftOuter](#LeftOuter).

## Join Families

### <span id="InnerLike"> InnerLike

`InnerLike` with [Inner](#Inner) and [Cross](#Cross)

### <span id="LeftExistence"> LeftExistence

`LeftExistence` with [LeftSemi](#LeftSemi), [LeftAnti](#LeftAnti) and [ExistenceJoin](#ExistenceJoin)

## Demo

```text
val left = Seq((0, "zero"), (1, "one")).toDF("id", "left")
val right = Seq((0, "zero"), (2, "two"), (3, "three")).toDF("id", "right")
```

### Inner join

```scala
val q = left.join(right, "id")
```

```text
+---+----+-----+
| id|left|right|
+---+----+-----+
|  0|zero| zero|
+---+----+-----+
```

```text
== Physical Plan ==
*(1) Project [id#7, left#8, right#19]
+- *(1) BroadcastHashJoin [id#7], [id#18], Inner, BuildLeft, false
   :- BroadcastExchange HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [id=#15]
   :  +- LocalTableScan [id#7, left#8]
   +- *(1) LocalTableScan [id#18, right#19]
```

### Full outer

```scala
val q = left.join(right, Seq("id"), "fullouter")
```

```text
+---+----+-----+
| id|left|right|
+---+----+-----+
|  1| one| null|
|  3|null|three|
|  2|null|  two|
|  0|zero| zero|
+---+----+-----+
```

```text
== Physical Plan ==
*(3) Project [coalesce(id#7, id#18) AS id#25, left#8, right#19]
+- SortMergeJoin [id#7], [id#18], FullOuter
   :- *(1) Sort [id#7 ASC NULLS FIRST], false, 0
   :  +- Exchange hashpartitioning(id#7, 200), ENSURE_REQUIREMENTS, [id=#38]
   :     +- LocalTableScan [id#7, left#8]
   +- *(2) Sort [id#18 ASC NULLS FIRST], false, 0
      +- Exchange hashpartitioning(id#18, 200), ENSURE_REQUIREMENTS, [id=#39]
         +- LocalTableScan [id#18, right#19]
```

### Left Anti

```scala
val q = left.join(right, Seq("id"), "leftanti")
```

```text
+---+----+
| id|left|
+---+----+
|  1| one|
+---+----+
```

```text
== Physical Plan ==
*(1) BroadcastHashJoin [id#7], [id#18], LeftAnti, BuildRight, false
:- *(1) LocalTableScan [id#7, left#8]
+- BroadcastExchange HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [id=#65]
   +- LocalTableScan [id#18]
```
