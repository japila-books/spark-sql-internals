---
title: AppendData
---

# AppendData Logical Command

`AppendData` is a [V2WriteCommand](V2WriteCommand.md) that represents appending data (the result of executing a [structured query](#query)) to a [table](#table) (with the [columns matching](#isByName) by [name](#byName) or [position](#byPosition)).

## Creating Instance

`AppendData` takes the following to be created:

* <span id="table"> [NamedRelation](NamedRelation.md) for the table (to append data to)
* <span id="query"> Query ([LogicalPlan](LogicalPlan.md))
* <span id="writeOptions"> Write Options (`Map[String, String]`)
* [isByName](#isByName) flag
* <span id="write"> [Write](../connector/Write.md)

`AppendData` is created using [byName](#byName) and [byPosition](#byPosition) operators.

### <span id="isByName"> isByName flag

`AppendData` is given `isByName` flag when [created](#creating-instance):

* [byName](#byName) with the flag enabled (`true`)
* [byPosition](#byPosition) with the flag disabled (`false`)

`isByName` is part of the [V2WriteCommand](V2WriteCommand.md#isByName) abstraction.

## <span id="byName"> byName

```scala
byName(
  table: NamedRelation,
  df: LogicalPlan,
  writeOptions: Map[String, String] = Map.empty): AppendData
```

`byName` creates a [AppendData](#creating-instance) with the [isByName](#isByName) flag enabled (`true`).

`byName` is used when:

* `DataFrameWriter` is requested to [saveInternal](../DataFrameWriter.md#saveInternal) (with `SaveMode.Append` mode) and [saveAsTable](../DataFrameWriter.md#saveAsTable) (with `SaveMode.Append` mode)
* `DataFrameWriterV2` is requested to [append](../DataFrameWriterV2.md#append)

## <span id="byPosition"> byPosition

```scala
byPosition(
  table: NamedRelation,
  query: LogicalPlan,
  writeOptions: Map[String, String] = Map.empty): AppendData
```

`byPosition` creates a [AppendData](#creating-instance) with the [isByName](#isByName) flag disabled (`false`).

`byPosition` is used when:

* [ResolveInsertInto](../logical-analysis-rules/ResolveInsertInto.md) logical resolution rule is executed
* `DataFrameWriter` is requested to [insertInto](../DataFrameWriter.md#insertInto)

## Execution Planning

`AppendData` is planned as one of the physical operators by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy:

* `AppendDataExecV1`
* `AppendDataExec`
