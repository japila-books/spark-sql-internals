# CheckAnalysis &mdash; Analysis Validation

`CheckAnalysis` is an [extension](#contract) of the [PredicateHelper](PredicateHelper.md) abstraction for [logical analysis checkers](#implementations) that can [check analysis phase](#checkAnalysis).

`CheckAnalysis` defines [extendedCheckRules](#extendedCheckRules) extension point for extra analysis check rules.

!!! note
    Only after [analysis](QueryExecution.md#analyzed) a logical query plan is correct and ready for execution.

## Contract

### <span id="isView"> isView

```scala
isView(
  nameParts: Seq[String]): Boolean
```

Used when:

* `CheckAnalysis` is requested to [check analysis](#checkAnalysis) (of a logical plan with [UnresolvedV2Relation](logical-operators/UnresolvedV2Relation.md)s)

## Implementations

* [Analyzer](Analyzer.md)

## <span id="extendedCheckRules"> extendedCheckRules Extension Point

```scala
extendedCheckRules: Seq[LogicalPlan => Unit] = Nil
```

`CheckAnalysis` allows [implementations](#implementations) for extra analysis check rules using `extendedCheckRules` extension point.

Used after the built-in check rules have been [evaluated](#checkAnalysis).

## <span id="checkAnalysis"> Checking Analysis Phase

```scala
checkAnalysis(
  plan: LogicalPlan): Unit
```

`checkAnalysis` checks (_asserts_) whether the given [logical plan](logical-operators/LogicalPlan.md) is correct using built-in and [extended](#extendedCheckRules) validation rules followed by [marking it as analyzed](logical-operators/LogicalPlan.md#setAnalyzed).

`checkAnalysis` traverses the operators from their [children](catalyst/TreeNode.md#children) first (up the operator chain).

`checkAnalysis` skips analysis if the plan has already been analyzed.

### <span id="checkAnalysis-unresolved"> Unresolved Operators

`checkAnalysis` checks whether the plan has any [logical plans unresolved](logical-operators/LogicalPlan.md#resolved). If so, `checkAnalysis` [fails the analysis](#failAnalysis) with the following error message:

```text
unresolved operator [o.simpleString]
```

### <span id="checkAnalysis-setAnalyzed"> Logical Plan Analyzed

In the end, `checkAnalysis` [marks the entire logical plan as analyzed](logical-operators/LogicalPlan.md#setAnalyzed).

### <span id="checkAnalysis-usage"> Usage

`checkAnalysis` is used when:

* `Analyzer` is requested to [executeAndCheck](Analyzer.md#executeAndCheck)
* [ResolveRelations](logical-analysis-rules/ResolveRelations.md) logical resolution rule is executed (and [resolveViews](logical-analysis-rules/ResolveRelations.md#resolveViews))
* [ResolveAggregateFunctions](logical-analysis-rules/ResolveAggregateFunctions.md) logical resolution rule is executed
* `CheckAnalysis` is requested to [checkSubqueryExpression](#checkSubqueryExpression)
* Catalyst DSL's [analyze](catalyst-dsl/DslLogicalPlan.md#analyze) operator is used
* `ExpressionEncoder` is requested to [resolveAndBind](ExpressionEncoder.md#resolveAndBind)
* [RelationalGroupedDataset.as](RelationalGroupedDataset.md#as) operator is used
