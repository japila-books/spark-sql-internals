# WindowsSubstitution Logical Evaluation Rule

`WindowsSubstitution` is a [logical evaluation rule](../catalyst/Rule.md) (`Rule[LogicalPlan]`) that the [Logical Analyzer](../Analyzer.md) uses to resolve (_aka_ substitute) [WithWindowDefinition](../logical-operators/WithWindowDefinition.md) unary logical operators with <<spark-sql-Expression-UnresolvedWindowExpression.md#, UnresolvedWindowExpression>> to their corresponding spark-sql-Expression-WindowExpression.md[WindowExpression] with resolved spark-sql-Expression-WindowSpecDefinition.md[WindowSpecDefinition].

`WindowsSubstitution` is part of [Substitution](../Analyzer.md#Substitution) fixed-point batch of rules.

NOTE: It _appears_ that `WindowsSubstitution` is exclusively used for pure SQL queries because spark-sql-LogicalPlan-WithWindowDefinition.md[WithWindowDefinition] unary logical operator is created exclusively when `AstBuilder` spark-sql-LogicalPlan-WithWindowDefinition.md#creating-instance[parses window definitions].

If a window specification is not found, `WindowsSubstitution` fails analysis with the following error:

```
Window specification [windowName] is not defined in the WINDOW clause.
```

NOTE: The analysis failure is unlikely to happen given `AstBuilder` spark-sql-AstBuilder.md#withWindows[builds a lookup table of all the named window specifications] defined in a SQL text and reports a `ParseException` when a `WindowSpecReference` is not available earlier.

For every `WithWindowDefinition`, `WindowsSubstitution` takes the `child` logical plan and transforms its <<spark-sql-Expression-UnresolvedWindowExpression.md#, UnresolvedWindowExpression>> expressions to be a spark-sql-Expression-WindowExpression.md[WindowExpression] with a window specification from the `WINDOW` clause (see spark-sql-Expression-WindowExpression.md#WithWindowDefinition-example[WithWindowDefinition Example]).
