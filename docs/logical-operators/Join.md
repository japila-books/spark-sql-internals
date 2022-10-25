# Join Logical Operator

`Join` is a [binary logical operator](LogicalPlan.md#BinaryNode) that represents the following high-level operators in a logical plan:

* [JOIN](../sql/AstBuilder.md#withJoinRelations) SQL statement
* [Dataset.crossJoin](../joins.md#crossJoin), [Dataset.join](../joins.md#join) and [Dataset.joinWith](../joins.md#joinWith) operators

## Creating Instance

`Join` takes the following to be created:

* <span id="left"> Left [logical operator](LogicalPlan.md)
* <span id="right"> Right [logical operator](LogicalPlan.md)
* <span id="joinType"> [JoinType](../joins.md#join-types)
* <span id="condition"> Optional Join [Expression](../expressions/Expression.md)
* <span id="hint"> `JoinHint`

`Join` is created when:

* `AstBuilder` is requested to [withJoinRelations](../sql/AstBuilder.md#withJoinRelations) (and [visitFromClause](../sql/AstBuilder.md#visitFromClause))
* [Dataset.crossJoin](../joins.md#crossJoin), [Dataset.join](../joins.md#join) and [Dataset.joinWith](../joins.md#joinWith) operators are used

## Catalyst DSL

`DslLogicalPlan` defines [join](../catalyst-dsl/DslLogicalPlan.md#join) operator to create a `Join`.

```scala
import org.apache.spark.sql.catalyst.dsl.plans._
val t1 = table("t1")
val t2 = table("t2")
val j = t1.join(t2)

import org.apache.spark.sql.catalyst.plans.logical.Join
assert(j.isInstanceOf[Join])
```
