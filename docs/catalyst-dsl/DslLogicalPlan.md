# DslLogicalPlan

`DslLogicalPlan` is part of [Catalyst DSL](index.md) to build entire [logical plans](../logical-operators/LogicalPlan.md).

```scala
implicit class DslLogicalPlan(logicalPlan: LogicalPlan)
```

`DslLogicalPlan` is part of the `org.apache.spark.sql.catalyst.dsl.plans` object.

```scala
import org.apache.spark.sql.catalyst.dsl.plans._
```

## <span id="analyze"> analyze

```scala
analyze: LogicalPlan
```

Resolves attribute references (using [EliminateSubqueryAliases](../logical-optimizations/EliminateSubqueryAliases.md) logical optimization and `SimpleAnalyzer` logical analyzer)

## Operators

### <span id="deserialize"> deserialize

```scala
deserialize[T : Encoder]: LogicalPlan
```

`deserialize` creates an [DeserializeToObject](../CatalystSerde.md#deserialize) logical operator

### <span id="groupBy"> groupBy

```scala
groupBy(
  groupingExprs: Expression*)(
  aggregateExprs: Expression*): LogicalPlan
```

`groupBy` creates an [Aggregate](../logical-operators/Aggregate.md) logical operator

### <span id="hint"> hint

```scala
hint(
  name: String,
  parameters: Any*): LogicalPlan
```

Creates an [UnresolvedHint](../logical-operators/UnresolvedHint.md) logical operator

### <span id="join"> join

```scala
join(
  otherPlan: LogicalPlan,
  joinType: JoinType = Inner,
  condition: Option[Expression] = None): LogicalPlan
```

Creates a [Join](../logical-operators/Join.md) logical operator

### <span id="orderBy"> orderBy

```scala
orderBy(
  sortExprs: SortOrder*): LogicalPlan
```

Creates a [Sort](../logical-operators/Sort.md) logical operator (with the [global sorting](../logical-operators/Sort.md#global))

### <span id="sortBy"> sortBy

```scala
sortBy(
  sortExprs: SortOrder*): LogicalPlan
```

Creates a [Sort](../logical-operators/Sort.md) logical operator (without [global sorting](../logical-operators/Sort.md#global))

## Demo

```text
// Import plans object
// That loads implicit class DslLogicalPlan
// And so every LogicalPlan is the "target" of the DslLogicalPlan methods
import org.apache.spark.sql.catalyst.dsl.plans._

val t1 = table(ref = "t1")

// HACK: Disable symbolToColumn implicit conversion
// It is imported automatically in spark-shell (and makes demos impossible)
// implicit def symbolToColumn(s: Symbol): org.apache.spark.sql.ColumnName
trait ThatWasABadIdea
implicit def symbolToColumn(ack: ThatWasABadIdea) = ack

import org.apache.spark.sql.catalyst.dsl.expressions._
val id = 'id.long
val logicalPlan = t1.select(id)
scala> println(logicalPlan.numberedTreeString)
00 'Project [id#1L]
01 +- 'UnresolvedRelation `t1`

val t2 = table("t2")
import org.apache.spark.sql.catalyst.plans.LeftSemi
val logicalPlan = t1.join(t2, joinType = LeftSemi, condition = Some(id))
scala> println(logicalPlan.numberedTreeString)
00 'Join LeftSemi, id#1: bigint
01 :- 'UnresolvedRelation `t1`
02 +- 'UnresolvedRelation `t2`
```
