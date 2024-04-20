# PredicateHelper

## isLikelySelective { #isLikelySelective }

```scala
isLikelySelective(
  e: Expression): Boolean
```

`isLikelySelective` is `true` (enabled) for the following [Expression](expressions/Expression.md)s:

* `Not` with an [Expression](expressions/Expression.md) that is likely to be selective
* `And` with either [Expression](expressions/Expression.md) likely to be selective
* `Or` with both [Expression](expressions/Expression.md)s likely to be selective
* `StringRegexExpression`
    * `Like`
    * `RLike`
* `BinaryComparison`
    * `EqualNullSafe`
    * `EqualTo`
    * `GreaterThan`
    * `GreaterThanOrEqual`
    * `LessThan`
    * `LessThanOrEqual`
* [In](expressions/In.md)
* [InSet](expressions/InSet.md)
* `StringPredicate`
    * `Contains`
    * `EndsWith`
    * `StartsWith`
* `BinaryPredicate`
* `MultiLikeBase`
    * `LikeAll`
    * `NotLikeAll`
    * `LikeAny`
    * `NotLikeAny`

---

`isLikelySelective` is used when:

* `InjectRuntimeFilter` logical optimization is requested to [isSelectiveFilterOverScan](logical-optimizations/InjectRuntimeFilter.md#isSelectiveFilterOverScan)
* `PartitionPruning` logical optimization is requested to [hasSelectivePredicate](logical-optimizations/PartitionPruning.md#hasSelectivePredicate)

## findExpressionAndTrackLineageDown { #findExpressionAndTrackLineageDown }

```scala
findExpressionAndTrackLineageDown(
  exp: Expression,
  plan: LogicalPlan): Option[(Expression, LogicalPlan)]
```

`findExpressionAndTrackLineageDown` returns `None` for no [references](expressions/Expression.md#references) in the given [Expression](expressions/Expression.md).

For a [Project](logical-operators/Project.md) logical operator, `findExpressionAndTrackLineageDown`...FIXME

For a [Aggregate](logical-operators/Aggregate.md) logical operator, `findExpressionAndTrackLineageDown`...FIXME

For any [LeafNode](logical-operators/LeafNode.md) logical operator with the [output attributes](catalyst/QueryPlan.md#outputSet) being the superset of the [references](expressions/Expression.md#references) of the given [Expression](expressions/Expression.md), `findExpressionAndTrackLineageDown` returns a pair of the [Expression](expressions/Expression.md) and the [LeafNode](logical-operators/LeafNode.md).

For a `Union` logical operator, `findExpressionAndTrackLineageDown`...FIXME

For any other [logical operator](logical-operators/LogicalPlan.md), `findExpressionAndTrackLineageDown` checks the [child logical operator](catalyst/TreeNode.md#children) one by one, recursively, and only when the [references](expressions/Expression.md#references) of the given [Expression](expressions/Expression.md) are all among the [output attributes](catalyst/QueryPlan.md#outputSet) of a child operator.

---

`findExpressionAndTrackLineageDown` is used when:

* [InjectRuntimeFilter](logical-optimizations/InjectRuntimeFilter.md) logical optimization is executed (to [extractBeneficialFilterCreatePlan](logical-optimizations/InjectRuntimeFilter.md#extractBeneficialFilterCreatePlan))
* [PartitionPruning](logical-optimizations/PartitionPruning.md) logical optimization is executed (to [getFilterableTableScan](logical-optimizations/PartitionPruning.md#getFilterableTableScan))

<!---
## Review Me

=== [[splitConjunctivePredicates]] Splitting Conjunctive Predicates -- `splitConjunctivePredicates` Method

[source, scala]
----
splitConjunctivePredicates(condition: Expression): Seq[Expression]
----

`splitConjunctivePredicates` takes the input condition expressions/Expression.md[expression] and splits it to two expressions if they are children of a `And` binary expression.

`splitConjunctivePredicates` splits the child expressions recursively down the child expressions until no conjunctive `And` binary expressions exist.

=== [[canEvaluateWithinJoin]] `canEvaluateWithinJoin` Method

[source, scala]
----
canEvaluateWithinJoin(expr: Expression): Boolean
----

`canEvaluateWithinJoin` indicates whether a expressions/Expression.md[Catalyst expression] _can be evaluated within a join_, i.e. when one of the following conditions holds:

* Expression is expressions/Expression.md#deterministic[deterministic]

* Expression is not [Unevaluable](expressions/Unevaluable.md), `ListQuery` or `Exists`

* Expression is a `SubqueryExpression` with no child expressions

* Expression is a `AttributeReference`

* Any expression with child expressions that meet one of the above conditions

[NOTE]
====
`canEvaluateWithinJoin` is used when:

* `PushPredicateThroughJoin` logical optimization rule is PushPredicateThroughJoin.md#apply[executed]

* `ReorderJoin` logical optimization rule does ReorderJoin.md#createOrderedJoin[createOrderedJoin]
====
-->
