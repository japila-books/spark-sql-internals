# V2CommandExec Physical Commands

`V2CommandExec` is an [extension](#contract) of the [SparkPlan](SparkPlan.md) abstraction for [physical commands](#implementations) that can be [executed](#run) and cache the [result](#result) to prevent [multiple executions](#doExecute).

## Contract

### <span id="run"> run

```scala
run(): Seq[InternalRow]
```

Executing the command (and computing the [result](#result))

Used when `V2CommandExec` physical command is requested for a [result](#result).

## Implementations

* <span id="AlterNamespaceSetPropertiesExec"> `AlterNamespaceSetPropertiesExec`
* <span id="AlterTableExec"> `AlterTableExec`
* <span id="AtomicReplaceTableExec"> `AtomicReplaceTableExec`
* <span id="CreateNamespaceExec"> `CreateNamespaceExec`
* <span id="CreateTableExec"> `CreateTableExec`
* <span id="DeleteFromTableExec"> `DeleteFromTableExec`
* <span id="DescribeNamespaceExec"> `DescribeNamespaceExec`
* <span id="DescribeTableExec"> `DescribeTableExec`
* <span id="DropNamespaceExec"> `DropNamespaceExec`
* <span id="DropTableExec"> `DropTableExec`
* <span id="RefreshTableExec"> `RefreshTableExec`
* <span id="RenameTableExec"> `RenameTableExec`
* <span id="ReplaceTableExec"> `ReplaceTableExec`
* <span id="SetCatalogAndNamespaceExec"> [SetCatalogAndNamespaceExec](SetCatalogAndNamespaceExec.md)
* <span id="ShowCurrentNamespaceExec"> [ShowCurrentNamespaceExec](ShowCurrentNamespaceExec.md)
* <span id="ShowNamespacesExec"> `ShowNamespacesExec`
* <span id="ShowTablePropertiesExec"> `ShowTablePropertiesExec`
* <span id="ShowTablesExec"> `ShowTablesExec`
* <span id="V1FallbackWriters"> `V1FallbackWriters`
* <span id="V2TableWriteExec"> `V2TableWriteExec`

## <span id="result"> result

```scala
result: Seq[InternalRow]
```

`result` is the cached result of [executing the physical command](#run).

`result` is used when `V2CommandExec` physical command is requested to [doExecute](#doExecute), [executeCollect](#executeCollect), [executeToIterator](#executeToIterator), [executeTake](#executeTake) or [executeTail](#executeTail).

## <span id="doExecute"> doExecute

```scala
doExecute(): RDD[InternalRow]
```

`doExecute`...FIXME

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

## <span id="executeCollect"> executeCollect

```scala
executeCollect(): Array[InternalRow]
```

`executeCollect`...FIXME

`executeCollect` is part of the [SparkPlan](SparkPlan.md#executeCollect) abstraction.

## <span id="executeToIterator"> executeToIterator

```scala
executeToIterator: Iterator[InternalRow]
```

`executeToIterator`...FIXME

`executeToIterator` is part of the [SparkPlan](SparkPlan.md#executeToIterator) abstraction.

## <span id="executeTake"> executeTake

```scala
executeTake(
  limit: Int): Array[InternalRow]
```

`executeTake`...FIXME

`executeTake` is part of the [SparkPlan](SparkPlan.md#executeTake) abstraction.

## <span id="executeTail"> executeTail

```scala
executeTail(
  limit: Int): Array[InternalRow]
```

`executeTail`...FIXME

`executeTail` is part of the [SparkPlan](SparkPlan.md#executeTail) abstraction.
