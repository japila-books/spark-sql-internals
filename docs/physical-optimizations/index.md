# Physical Optimizations

**Physical Optimizations** (_physical query preparation rules_, _preparation rules_) are used by [QueryExecution](../QueryExecution.md#preparations) to optimize (_transform_) the physical plan of structured queries.

`QueryExecution` uses physical optimizations when requested for the [optimized physical query plan](../QueryExecution.md#executedPlan) (i.e. in _executedPlan_ phase of a query execution).

!!! note "FIXME Mention AQE"
