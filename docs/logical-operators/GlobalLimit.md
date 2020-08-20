# GlobalLimit Logical Operator

`GlobalLimit` is an [order-preserving unary logical operator](OrderPreservingUnaryNode.md).

## Creating Instance

`GlobalLimit` takes the following to be created:

* <span id="limitExpr"> Limit [Expression](../expressions/Expression.md)
* <span id="child"> Child [query plan](LogicalPlan.md)

`GlobalLimit` is created using [Limit.apply](#apply) utility.

## Query Planning

`GlobalLimit` is planned to `GlobalLimitExec` physical operator (when [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed).

## Query Physical Optimization

* `CombineLimits` physical optimization

## <span id="apply"> apply Utility

```scala
apply(
  limitExpr: Expression,
  child: LogicalPlan): UnaryNode
```

`apply` creates a `GlobalLimit` for the given `limitExpr` expression and a `LocalLimit` logical operator.

`apply` is used when:

* [AstBuilder](../sql/AstBuilder.md) is requested to [withQueryResultClauses](../sql/AstBuilder.md#withQueryResultClauses) and [withSample](../sql/AstBuilder.md#withSample)
* `Dataset.limit` operator is used
* `RewriteNonCorrelatedExists` logical optimization is executed
* `CombineLimits` physical optimization is executed
* [Catalyst DSL](../spark-sql-catalyst-dsl.md)'s `limit` operator is used

## Example

```text
val q = spark.range(10).limit(3)
scala> q.explain(extended = true)
== Parsed Logical Plan ==
GlobalLimit 3
+- LocalLimit 3
   +- Range (0, 10, step=1, splits=Some(16))

== Analyzed Logical Plan ==
id: bigint
GlobalLimit 3
+- LocalLimit 3
   +- Range (0, 10, step=1, splits=Some(16))

== Optimized Logical Plan ==
GlobalLimit 3
+- LocalLimit 3
   +- Range (0, 10, step=1, splits=Some(16))

== Physical Plan ==
CollectLimit 3
+- *(1) Range (0, 10, step=1, splits=16)
```
