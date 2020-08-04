# TypeCoercion Object

`TypeCoercion` is a Scala object that defines the <<typeCoercionRules, type coercion rules>> for [Logical Analyzer](Analyzer.md#typeCoercionRules).

## <span id="typeCoercionRules"> Defining Type Coercion Analysis Rules

```scala
typeCoercionRules(
  conf: SQLConf): List[Rule[LogicalPlan]]
```

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

`typeCoercionRules` is used when `Analyzer` is requested for [batches](Analyzer.md#batches).
