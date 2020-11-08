# DescribeTableExec Physical Command

`DescribeTableExec` is a [physical command](V2CommandExec.md) that represents [DescribeRelation](../logical-operators/DescribeRelation.md) logical command at execution time.

## Creating Instance

`DescribeTableExec` takes the following to be created:

* <span id="output"> Output [Attribute](../expressions/Attribute.md)s
* <span id="table"> [Table](../connector/Table.md)
* <span id="isExtended"> `isExtended` flag

`DescribeTableExec` is created when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (and plans a [DescribeRelation](../logical-operators/DescribeRelation.md) logical command).

## <span id="run"> Executing Command

```scala
run(): Seq[InternalRow]
```

`run`...FIXME

`run` is part of the [V2CommandExec](V2CommandExec.md#run) abstraction.
