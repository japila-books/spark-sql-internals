---
title: V2ExistingTableWriteExec
---

# V2ExistingTableWriteExec Unary Physical Commands

`V2ExistingTableWriteExec` is an [extension](#contract) of the [V2TableWriteExec](V2TableWriteExec.md) abstraction for [unary physical commands](#implementations) that [refreshCache](#refreshCache) after writing data out to a [writable table](#write) when [executed](#run).

## Contract

### refreshCache { #refreshCache }

```scala
refreshCache: () => Unit
```

Used when:

* `V2ExistingTableWriteExec` is [executed](#run)

### write { #write }

```scala
write: Write
```

[Write](../connector/Write.md)-able table to write data out to

Used when:

* `V2ExistingTableWriteExec` is requested for the [customMetrics](#customMetrics) and to [execute](#run)

## Implementations

* `AppendDataExec`
* [OverwriteByExpressionExec](OverwriteByExpressionExec.md)
* `OverwritePartitionsDynamicExec`
* `ReplaceDataExec`
* `WriteDeltaExec`

## Executing Command { #run }

??? note "V2CommandExec"

    ```scala
    run(): Seq[InternalRow]
    ```

    `run` is part of the [V2CommandExec](V2CommandExec.md#run) abstraction.

`run`...FIXME
