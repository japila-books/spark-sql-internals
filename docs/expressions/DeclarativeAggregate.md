title: DeclarativeAggregate

# DeclarativeAggregate -- Unevaluable Aggregate Function Expressions

`DeclarativeAggregate` is an <<contract, extension>> of the <<spark-sql-Expression-AggregateFunction.md#, AggregateFunction Contract>> for <<implementations, aggregate function expressions>> that are <<expressions/Expression.md#Unevaluable, unevaluable>> and use expressions for evaluation.

NOTE: An <<expressions/Expression.md#Unevaluable, unevaluable expression>> cannot be evaluated to produce a value (neither in <<expressions/Expression.md#eval, interpreted>> nor <<expressions/Expression.md#doGenCode, code-generated>> expression evaluations) and has to be resolved (replaced) to some other expressions or logical operators at <<spark-sql-QueryExecution.md#analyzed, analysis>> or <<spark-sql-QueryExecution.md#optimizedPlan, optimization>> phases or they fail analysis.

[[contract]]
.DeclarativeAggregate Contract
[cols="1m,2",options="header",width="100%"]
|===
| Property
| Description

| evaluateExpression
a| [[evaluateExpression]]

[source, scala]
----
evaluateExpression: Expression
----

The <<expressions/Expression.md#, expression>> that returns the final value for the aggregate function

Used when:

* `AggregationIterator` is requested for the <<spark-sql-AggregationIterator.md#generateResultProjection, generateResultProjection>>

* `HashAggregateExec` physical operator is requested to <<spark-sql-SparkPlan-HashAggregateExec.md#doProduceWithoutKeys, doProduceWithoutKeys>> and <<spark-sql-SparkPlan-HashAggregateExec.md#generateResultFunction, generateResultFunction>>

* `AggregateProcessor` is <<spark-sql-AggregateProcessor.md#apply, created>> (when `WindowExec` physical operator is <<spark-sql-SparkPlan-WindowExec.md#, executed>>)

| initialValues
a| [[initialValues]]

[source, scala]
----
initialValues: Seq[Expression]
----

| mergeExpressions
a| [[mergeExpressions]]

[source, scala]
----
mergeExpressions: Seq[Expression]
----

| updateExpressions
a| [[updateExpressions]]

[source, scala]
----
updateExpressions: Seq[Expression]
----

|===

[[extensions]]
.DeclarativeAggregates (Direct Implementations)
[cols="1,2",options="header",width="100%"]
|===
| DeclarativeAggregate
| Description

| <<spark-sql-Expression-AggregateWindowFunction.md#, AggregateWindowFunction>>
| [[AggregateWindowFunction]] Contract for declarative window aggregate function expressions

| Average
| [[Average]]

| CentralMomentAgg
| [[CentralMomentAgg]]

| Corr
| [[Corr]]

| Count
| [[Count]]

| Covariance
| [[Covariance]]

| <<spark-sql-Expression-First.md#, First>>
| [[First]]

| Last
| [[Last]]

| Max
| [[Max]]

| Min
| [[Min]]

| <<spark-sql-Expression-SimpleTypedAggregateExpression.md#, SimpleTypedAggregateExpression>>
| [[SimpleTypedAggregateExpression]]

| Sum
| [[Sum]]
|===
