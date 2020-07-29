# TypeCoercion Object

`TypeCoercion` is a Scala object that defines the <<typeCoercionRules, type coercion rules>> for <<spark-sql-Analyzer.md#typeCoercionRules, Spark Analyzer>>.

=== [[typeCoercionRules]] Defining Type Coercion Rules (For Spark Analyzer) -- `typeCoercionRules` Method

[source, scala]
----
typeCoercionRules(conf: SQLConf): List[Rule[LogicalPlan]]
----

`typeCoercionRules` is a collection of <<catalyst/Rule.md#, Catalyst rules>> to transform <<spark-sql-LogicalPlan.md#, logical plans>> (in the order of execution):

* [InConversion](logical-analysis-rules/InConversion.md)
* `WidenSetOperationTypes`
* `PromoteStrings`
* `DecimalPrecision`
* `BooleanEquality`
* `FunctionArgumentConversion`
* `ConcatCoercion`
* `EltCoercion`
* `CaseWhenCoercion`
* `IfCoercion`
* `StackCoercion`
* `Division`
* `ImplicitTypeCasts`
* `DateTimeOperations`
* [WindowFrameCoercion](logical-analysis-rules/WindowFrameCoercion.md)

NOTE: `typeCoercionRules` is used exclusively when `Analyzer` is requested for <<spark-sql-Analyzer.md#batches, batches>>.
