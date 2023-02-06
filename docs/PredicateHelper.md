# PredicateHelper

## <span id="isLikelySelective"> isLikelySelective

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

<!---
## Review Me

`PredicateHelper` defines the <<methods, methods>> that are used to work with predicates (mainly).

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
