# ReusedSubqueryExec Physical Operator

`ReusedSubqueryExec` is a [BaseSubqueryExec](BaseSubqueryExec.md) and a `LeafExecNode` with a [child BaseSubqueryExec](#child) physical operator.

`ReusedSubqueryExec` is a wrapper and delegates all activity (as a physical operator) to the [child BaseSubqueryExec](#child).

## Creating Instance

`ReusedSubqueryExec` takes the following to be created:

* <span id="child"> Child [BaseSubqueryExec](BaseSubqueryExec.md) physical operator

`ReusedSubqueryExec` is created when:

* [ReuseAdaptiveSubquery](../physical-optimizations/ReuseAdaptiveSubquery.md) physical optimization is executed
* [ReuseExchangeAndSubquery](../physical-optimizations/ReuseExchangeAndSubquery.md) physical optimization is executed
