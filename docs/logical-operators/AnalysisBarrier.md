# AnalysisBarrier Leaf Logical Operator

`AnalysisBarrier` is a [leaf logical operator](LeafNode.md) that is a wrapper of an <<child, analyzed logical plan>> to hide it from the Spark Analyzer. The purpose of `AnalysisBarrier` is to prevent the child logical plan from being analyzed again (and increasing the time spent on query analysis).

`AnalysisBarrier` is <<creating-instance, created>> when:

* `ResolveReferences` logical resolution rule is requested to [dedupRight](../logical-analysis-rules/ResolveReferences.md#dedupRight)

* `ResolveMissingReferences` logical resolution rule is requested to [resolveExprsAndAddMissingAttrs](../logical-analysis-rules/ResolveMissingReferences.md#resolveExprsAndAddMissingAttrs)

* `Dataset` is [created](../Dataset.md#planWithBarrier)

* `DataFrameWriter` is requested to [execute a logical command for writing to a data source V1](../DataFrameWriter.md#saveToV1Source) (when `DataFrameWriter` is requested to [save the rows of a structured query (a DataFrame) to a data source](../DataFrameWriter.md#save))

* `KeyValueGroupedDataset` is requested for the [logical query plan](../spark-sql-KeyValueGroupedDataset.md#logicalPlan)

[[child]]
[[creating-instance]]
`AnalysisBarrier` takes a single `child` <<spark-sql-LogicalPlan.md#, logical query plan>> when created.

[[innerChildren]]
`AnalysisBarrier` returns the <<child, child logical query plan>> when requested for the [inner nodes](../catalyst/TreeNode.md#innerChildren) (that should be shown as an inner nested tree of this node).

[[output]]
`AnalysisBarrier` simply requests the <<child, child logical query plan>> for the <<catalyst/QueryPlan.md#output, output schema attributes>>.

[[isStreaming]]
`AnalysisBarrier` simply requests the <<child, child logical query plan>> for the <<spark-sql-LogicalPlan.md#isStreaming, isStreaming>> flag.

[[doCanonicalize]]
`AnalysisBarrier` simply requests the <<child, child logical operator>> for the <<catalyst/QueryPlan.md#doCanonicalize, canonicalized version>>.
