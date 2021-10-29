# DataSourceScanExec Leaf Physical Operators

`DataSourceScanExec` is an [extension](#contract) of the `LeafExecNode` abstraction for [leaf physical operators](#implementations) that represent scans over a [BaseRelation](#relation).

`DataSourceScanExec` uses `scan` for the [variable name prefix](CodegenSupport.md#variablePrefix) for [Whole-Stage Java Code Generation](../whole-stage-code-generation/index.md).

## Contract

### <span id="inputRDDs"> Input RDDs

```scala
inputRDDs(): Seq[RDD[InternalRow]]
```

!!! note
    This is to provide input to tests only.

### <span id="metadata"> Metadata

```scala
metadata: Map[String, String]
```

### <span id="relation"> BaseRelation

```scala
relation: BaseRelation
```

[BaseRelation](../BaseRelation.md)

### <span id="tableIdentifier"> TableIdentifier

```scala
tableIdentifier: Option[TableIdentifier]
```

## Implementations

* [FileSourceScanExec](FileSourceScanExec.md)
* [RowDataSourceScanExec](RowDataSourceScanExec.md)

## <span id="nodeName"> Node Name

```scala
nodeName: String
```

`nodeName` is part of the [TreeNode](../catalyst/TreeNode.md#nodeName) abstraction.

`nodeName` is the following text (with the [relation](#relation) and the [tableIdentifier](#tableIdentifier)):

```text
Scan [relation] [tableIdentifier]
```

## <span id="simpleString"> Simple Node Description

```scala
simpleString(
  maxFields: Int): String
```

`simpleString` is part of the [TreeNode](../catalyst/TreeNode.md#simpleString) abstraction.

`simpleString` is the following text (with the [nodeNamePrefix](#nodeNamePrefix), the [nodeName](#nodeName) and the [metadata](#metadata) redacted and truncated to [spark.sql.maxMetadataStringLength](../configuration-properties.md#spark.sql.maxMetadataStringLength) characters):

```text
[nodeNamePrefix][nodeName][comma-separated output][metadata]
```

### <span id="nodeNamePrefix"> Node Name Prefix

```scala
nodeNamePrefix: String
```

`nodeNamePrefix` is an empty text.
