# Aggregate Logical Operator

`Aggregate` is a [unary logical operator](LogicalPlan.md#UnaryNode) for [Aggregation Queries](../aggregations/index.md) and can represent the following high-level operators in a [logical query plan](LogicalPlan.md):

* `AstBuilder` is requested to [visitCommonSelectQueryClausePlan](../sql/AstBuilder.md#visitCommonSelectQueryClausePlan) (`HAVING` clause without `GROUP BY`) and [parse GROUP BY clause](../sql/AstBuilder.md#withAggregationClause)
* `KeyValueGroupedDataset` is requested to [agg](../KeyValueGroupedDataset.md#agg) (and [aggUntyped](../KeyValueGroupedDataset.md#aggUntyped))
* `RelationalGroupedDataset` is requested to [toDF](../RelationalGroupedDataset.md#toDF)

!!! note "Internal Use"
    `Aggregate` logical operator is also [used internally](#creating-instance) as part of logical and physical optimizations.

## Creating Instance

`Aggregate` takes the following to be created:

* <span id="groupingExpressions"> Grouping [Expression](../expressions/Expression.md)s
* <span id="aggregateExpressions"> Aggregate [NamedExpression](../expressions/NamedExpression.md)s
* <span id="child"> Child [LogicalPlan](LogicalPlan.md)

`Aggregate` is created when:

* `ResolveGroupingAnalytics` is requested to [constructAggregate](../logical-analysis-rules/ResolveGroupingAnalytics.md#constructAggregate)
* `ResolvePivot` logical resolution rule is executed
* `GlobalAggregates` logical resolution rule is executed
* Catalyst DSL's [groupBy](../catalyst-dsl/DslLogicalPlan.md#groupBy) operator is used
* `DecorrelateInnerQuery` is requested to `rewriteDomainJoins`
* `InjectRuntimeFilter` is requested to [injectBloomFilter](../logical-optimizations/InjectRuntimeFilter.md#injectBloomFilter) and [injectInSubqueryFilter](../logical-optimizations/InjectRuntimeFilter.md#injectInSubqueryFilter)
* `ReplaceDistinctWithAggregate` logical optimization is executed
* `ReplaceDeduplicateWithAggregate` logical optimization is executed
* [RewriteExceptAll](../logical-optimizations/RewriteExceptAll.md) logical optimization is executed
* `RewriteIntersectAll` logical optimization is executed
* `RewriteAsOfJoin` logical optimization is executed
* `AstBuilder` is requested to [visitCommonSelectQueryClausePlan](../sql/AstBuilder.md#visitCommonSelectQueryClausePlan) (for a global aggregate, i.e. `HAVING` without `GROUP BY`) and [withAggregationClause](../sql/AstBuilder.md#withAggregationClause)
* `KeyValueGroupedDataset` is requested to [aggUntyped](../KeyValueGroupedDataset.md#aggUntyped)
* `RelationalGroupedDataset` is requested to [toDF](../RelationalGroupedDataset.md#toDF)
* [PlanAdaptiveDynamicPruningFilters](../physical-optimizations/PlanAdaptiveDynamicPruningFilters.md) physical optimization is executed
* [PlanDynamicPruningFilters](../physical-optimizations/PlanDynamicPruningFilters.md) physical optimization is executed
* `CommandUtils` is requested to [computeColumnStats](../CommandUtils.md#computeColumnStats) and [computePercentiles](../CommandUtils.md#computePercentiles)
* `RowLevelOperationRuntimeGroupFiltering` logical optimization is executed
* _others_

## Output Schema { #output }

??? note "QueryPlan"

    ```scala
    output: Seq[Attribute]
    ```

    `output` is part of the [QueryPlan](../catalyst/QueryPlan.md#output) abstraction.

`output` is the [Attribute](../expressions/NamedExpression.md#toAttribute)s of the [aggregate expressions](#aggregateExpressions).

## Metadata Output Schema { #metadataOutput }

??? note "LogicalPlan"

    ```scala
    metadataOutput: Seq[Attribute]
    ```

    `metadataOutput` is part of the [LogicalPlan](LogicalPlan.md#metadataOutput) abstraction.

`metadataOutput` is empty (`Nil`).

## Node Patterns { #nodePatterns }

??? note "TreeNode"

    ```scala
    nodePatterns : Seq[TreePattern]
    ```

    `nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

`nodePatterns` is [AGGREGATE](../catalyst/TreePattern.md#AGGREGATE).

## <span id="supportsHashAggregate"> Checking Requirements for HashAggregateExec

```scala
supportsHashAggregate(
  aggregateBufferAttributes: Seq[Attribute]): Boolean
```

`supportsHashAggregate` [builds a StructType](../types/StructType.md#fromAttributes) for the given `aggregateBufferAttributes`.

In the end, `supportsHashAggregate` [isAggregateBufferMutable](#isAggregateBufferMutable).

---

`supportsHashAggregate` is used when:

* `MergeScalarSubqueries` is requested to `supportedAggregateMerge`
* `AggUtils` is requested to [create a physical operator for aggregation](../aggregations/AggUtils.md#createAggregate)
* `HashAggregateExec` physical operator is created (to assert that the [aggregateBufferAttributes](../physical-operators/HashAggregateExec.md#aggregateBufferAttributes) are supported)

## <span id="isAggregateBufferMutable"> isAggregateBufferMutable

```scala
isAggregateBufferMutable(
  schema: StructType): Boolean
```

`isAggregateBufferMutable` is enabled (`true`) when the [type](../types/StructField.md#dataType) of all the [fields](../types/StructField.md) (in the given `schema`) are [mutable](../UnsafeRow.md#isMutable).

---

`isAggregateBufferMutable` is used when:

* `Aggregate` is requested to [check the requirements for HashAggregateExec](#supportsHashAggregate)
* `UnsafeFixedWidthAggregationMap` is requested to [supportsAggregationBufferSchema](../aggregations/UnsafeFixedWidthAggregationMap.md#supportsAggregationBufferSchema)
