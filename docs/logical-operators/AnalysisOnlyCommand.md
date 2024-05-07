---
title: AnalysisOnlyCommand
---

# AnalysisOnlyCommand Logical Operators

`AnalysisOnlyCommand` is an [extension](#contract) of the [Command](Command.md) abstraction for [logical commands](#implementations) that can be [notified when analysis is done](#markAsAnalyzed).

## Contract

### childrenToAnalyze { #childrenToAnalyze }

```scala
childrenToAnalyze: Seq[LogicalPlan]
```

### isAnalyzed { #isAnalyzed }

```scala
isAnalyzed: Boolean
```

Whether this command is analyzed or not

Used when:

* `AnalysisOnlyCommand` is requested for the [children](#children) and [innerChildren](#innerChildren)

### markAsAnalyzed { #markAsAnalyzed }

```scala
markAsAnalyzed(
  analysisContext: AnalysisContext): LogicalPlan
```

Used when:

* `HandleSpecialCommand` logical analysis rule is executed

## Implementations

* `AlterViewAsCommand`
* `CacheTable`
* `CacheTableAsSelect`
* [CreateViewCommand](CreateViewCommand.md)
* `UncacheTable`
* `V2CreateTableAsSelectPlan`
