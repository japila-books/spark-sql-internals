---
title: WriteFiles
---

# WriteFiles Unary Logical Operator

`WriteFiles` is a [unary logical operator](LogicalPlan.md#UnaryNode).

## Creating Instance

`WriteFiles` takes the following to be created:

* <span id="child"> Child [LogicalPlan](LogicalPlan.md)
* <span id="fileFormat"> [FileFormat](../files/FileFormat.md)
* <span id="partitionColumns"> Partition Columns ([Attribute](../expressions/Attribute.md)s)
* <span id="bucketSpec"> [BucketSpec](../bucketing/BucketSpec.md)
* <span id="options"> Options
* <span id="staticPartitions"> Static Partitions (`TablePartitionSpec`)

`WriteFiles` is created when:

* `V1Writes` logical optimization is executed

## Query Execution

`WriteFiles` is planned as [WriteFilesExec](../physical-operators/WriteFilesExec.md) physical operator by [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy.
