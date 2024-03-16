---
title: BindParameters
---

# BindParameters Logical Analysis Rule

`BindParameters` is a [logical evaluation rule](../catalyst/Rule.md) (`Rule[LogicalPlan]`).

`BindParameters` is part of [Substitution](../Analyzer.md#Substitution) fixed-point batch of rules.

## Executing Rule { #apply }

??? note "Rule"

    ```scala
    apply(
      plan: LogicalPlan): LogicalPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` works on [LogicalPlan](../logical-operators/LogicalPlan.md)s with [PARAMETERIZED_QUERY](../catalyst/TreePattern.md#PARAMETERIZED_QUERY) tree pattern only.

`apply` makes sure that there's exactly one [ParameterizedQuery](../logical-operators/ParameterizedQuery.md) logical operator in the given [LogicalPlan](../logical-operators/LogicalPlan.md). Otherwise, `apply` throws an `AssertionError`:

```text
One unresolved plan can have at most one ParameterizedQuery
```

`apply` resolves the following logical operators in the given [LogicalPlan](../logical-operators/LogicalPlan.md):

* [NameParameterizedQuery](../logical-operators/NameParameterizedQuery.md)
* `PosParameterizedQuery`

`apply` [checks the arguments](#checkArgs) and replaces the names (or the positions) with their corresponding [Literal](../expressions/Literal.md)s.

### Binding { #bind }

```scala
bind(
  p: LogicalPlan)(
  f: PartialFunction[Expression, Expression]): LogicalPlan
```

`bind` resolves expressions with [PARAMETER](../catalyst/TreePattern.md#PARAMETER) tree pattern in the given [LogicalPlan](../logical-operators/LogicalPlan.md) (incl. [SubqueryExpression](../expressions/SubqueryExpression.md)s) using the given `f` partial function.

### Checking Arguments { #checkArgs }

```scala
checkArgs(
  args: Iterable[(String, Expression)]): Unit
```

??? warning "Procedure"
    `checkArgs` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`checkArgs` makes sure that the [Expression](../expressions/Expression.md)s in the given `args` collection are all [Literal](../expressions/Literal.md)s.

If not, `checkArgs` fails analysis with an `AnalysisException`:

```text
The argument [name] of `sql()` is invalid. Consider to replace it by a SQL literal.
```
