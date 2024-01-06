---
title: WriteFilesExec
---

# WriteFilesExec Unary Physical Operator

`WriteFilesExec` is a [UnaryExecNode](UnaryExecNode.md) physical operator that represents [WriteFiles](../logical-operators/WriteFiles.md) logical operator at execution time.

## Creating Instance

`WriteFilesExec` takes the following to be created:

* <span id="child"> Child [SparkPlan](SparkPlan.md)
* <span id="fileFormat"> [FileFormat](../files/FileFormat.md)
* <span id="partitionColumns"> Partition Columns ([Attribute](../expressions/Attribute.md)s)
* <span id="bucketSpec"> [BucketSpec](../bucketing/BucketSpec.md)
* <span id="options"> Options
* <span id="staticPartitions"> Static Partitions (`TablePartitionSpec`)

`WriteFilesExec` is created when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (to plan a `WriteFiles` logical operator)
