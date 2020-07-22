# QueryStageExec Leaf Physical Operators

`QueryStageExec` is an [extension](#contract) of the [LeafExecNode](LeafExecNode.md) abstraction for [leaf physical operators](#implementations) that [method](#method) and...FIXME.

## Contract

### <span id="cancel"> cancel

```scala
cancel(): Unit
```

Used when...FIXME

### <span id="doMaterialize"> doMaterialize

```scala
doMaterialize(): Future[Any]
```

Used when...FIXME

### <span id="id"> id

```scala
id: Int
```

Used when...FIXME

### <span id="newReuseInstance"> newReuseInstance

```scala
newReuseInstance(
  newStageId: Int,
  newOutput: Seq[Attribute]): QueryStageExec
```

Used when...FIXME

### <span id="plan"> plan

```scala
plan: SparkPlan
```

Used when...FIXME

## Implementations

* <span id="BroadcastQueryStageExec"> [BroadcastQueryStageExec](BroadcastQueryStageExec.md)
* <span id="ShuffleQueryStageExec"> [ShuffleQueryStageExec](ShuffleQueryStageExec.md)

## <span id="generateTreeString"> generateTreeString

```scala
generateTreeString(
  depth: Int,
  lastChildren: Seq[Boolean],
  append: String => Unit,
  verbose: Boolean,
  prefix: String = "",
  addSuffix: Boolean = false,
  maxFields: Int,
  printNodeId: Boolean): Unit
```

`generateTreeString`...FIXME

`generateTreeString` is part of the [TreeNode](../catalyst/TreeNode.md#generateTreeString) abstraction.

## <span id="computeStats"> computeStats

```scala
computeStats(): Option[Statistics]
```

`computeStats`...FIXME

`computeStats` is used when...FIXME
