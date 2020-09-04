# ColumnarRule

`ColumnarRule` is an [abstraction](#contract) to hold [preColumnarTransitions](#preColumnarTransitions) and [postColumnarTransitions](#postColumnarTransitions) user-defined rules to inject columnar [physical operators](physical-operators/SparkPlan.md) to a query plan (using [SparkSessionExtensions](SparkSessionExtensions.md#injectColumnar)).

!!! note
    [ApplyColumnarRulesAndInsertTransitions](physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md) physical optimization is used to execute `ColumnarRule`s.

## Contract

### <span id="preColumnarTransitions"> preColumnarTransitions

```scala
preColumnarTransitions: Rule[SparkPlan]
```

Used when [ApplyColumnarRulesAndInsertTransitions](physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md) physical optimization is executed.

### <span id="postColumnarTransitions"> postColumnarTransitions

```scala
postColumnarTransitions: Rule[SparkPlan]
```

Used when [ApplyColumnarRulesAndInsertTransitions](physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md) physical optimization is executed.
