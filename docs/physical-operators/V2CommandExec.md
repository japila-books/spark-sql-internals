---
title: V2CommandExec
---

# V2CommandExec Physical Commands

`V2CommandExec` is an [extension](#contract) of the [SparkPlan](SparkPlan.md) abstraction for [physical commands](#implementations) that can be [executed](#run) and cache the [result](#result) to prevent [multiple executions](#doExecute).

## Contract

### Executing Command { #run }

```scala
run(): Seq[InternalRow]
```

Executing the command (and computing the [result](#result))

See:

* [DropNamespaceExec](DropNamespaceExec.md#run)

Used when:

* `V2CommandExec` physical command is requested for the [result](#result)

## Implementations

* `LeafV2CommandExec`
* [ShowCreateTableExec](ShowCreateTableExec.md)
* `ShowNamespacesExec`
* `ShowPartitionsExec`
* [ShowTablesExec](ShowTablesExec.md)
* [V2TableWriteExec](V2TableWriteExec.md)

## Result

```scala
result: Seq[InternalRow]
```

`result` is the cached result of [executing the physical command](#run).

---

`result` is used when:

* `V2CommandExec` physical command is requested to [doExecute](#doExecute), [executeCollect](#executeCollect), [executeToIterator](#executeToIterator), [executeTake](#executeTake) or [executeTail](#executeTail)
