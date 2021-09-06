# Unevaluable Expressions

`Unevaluable` is an extension of the [Expression](Expression.md) abstraction for [unevaluable expression](#implementations) that cannot be evaluated to produce a value (neither in the [interpreted](Expression.md#eval) nor [code-generated](Expression.md#doGenCode) mode).

`Unevaluable` expressions are expected to be resolved (replaced) to "evaluable" expressions or logical operators at [analysis](../QueryExecution.md#analyzed) or [optimization](../QueryExecution.md#optimizedPlan) phases or they fail analysis.

Unevaluable expressions cannot be evaluated (neither in <<Expression.md#eval, interpreted>> nor <<Expression.md#doGenCode, code-generated>> expression evaluations) and has to be  

## Implementations

* [AggregateExpression](AggregateExpression.md)
* Assignment
* [AttributeReference](AttributeReference.md)
* CurrentDatabase
* [DeclarativeAggregate](DeclarativeAggregate.md)
* [DynamicPruningSubquery](DynamicPruningSubquery.md)
* [Exists](Exists.md)
* GetColumnByOrdinal
* Grouping
* GroupingID
* [HashPartitioning](HashPartitioning.md)
* [InSubquery](InSubquery.md)
* [ListQuery](ListQuery.md)
* MergeAction
* MultiAlias
* NamePlaceholder
* NoOp
* [OffsetWindowFunction](OffsetWindowFunction.md)
* OuterReference
* PartitioningCollection
* PartitionTransformExpression
* [PrettyAttribute](PrettyAttribute.md)
* PythonUDF
* RangePartitioning
* [ResolvedStar](ResolvedStar.md)
* [RuntimeReplaceable](RuntimeReplaceable.md)
* ScalarSubquery
* [SortOrder](SortOrder.md)
* SpecialFrameBoundary
* [TimeWindow](TimeWindow.md)
* UnresolvedAlias
* [UnresolvedAttribute](UnresolvedAttribute.md)
* UnresolvedCatalystToExternalMap
* UnresolvedDeserializer
* UnresolvedExtractValue
* [UnresolvedFunction](UnresolvedFunction.md)
* UnresolvedMapObjects
* UnresolvedNamedLambdaVariable
* [UnresolvedOrdinal](UnresolvedOrdinal.md)
* [UnresolvedRegex](UnresolvedRegex.md)
* [UnresolvedStar](UnresolvedStar.md)
* [UnresolvedWindowExpression](UnresolvedWindowExpression.md)
* UpCast
* [WindowExpression](WindowExpression.md)
* WindowFrame
* [WindowSpecDefinition](WindowSpecDefinition.md)
* _others_
