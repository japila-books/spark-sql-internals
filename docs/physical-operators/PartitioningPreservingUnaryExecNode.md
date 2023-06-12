# PartitioningPreservingUnaryExecNode Unary Physical Operators

`PartitioningPreservingUnaryExecNode` is an extension of the [UnaryExecNode](UnaryExecNode.md) abstraction for [unary physical operators](#implementations) with well-determined [output partitioning](#outputPartitioning).

`PartitioningPreservingUnaryExecNode` is [AliasAwareOutputExpression](AliasAwareOutputExpression.md).

## Implementations

* [BaseAggregateExec](BaseAggregateExec.md)
* [ProjectExec](ProjectExec.md)

## Output Data Partitioning Requirements { #outputPartitioning }

??? note "SparkPlan"

    ```scala
    outputPartitioning: Partitioning
    ```

    `outputPartitioning` is part of the [SparkPlan](SparkPlan.md#outputPartitioning) abstraction.

`outputPartitioning`...FIXME

??? note "Final Method"
    `outputPartitioning` is a Scala **final method** and may not be overridden in [subclasses](#implementations).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#final).
