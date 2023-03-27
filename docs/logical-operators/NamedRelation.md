# NamedRelation Logical Operators

`NamedRelation` is an [extension](#contract) of the [LogicalPlan](LogicalPlan.md) abstraction for [logical operators](#implementations) with a [name](#name) and support for [skipSchemaResolution](#skipSchemaResolution).

## Contract

### <span id="name"> Name

```scala
name: String
```

Name of this relation

### <span id="skipSchemaResolution"> skipSchemaResolution

```scala
skipSchemaResolution: Boolean
```

Indicates that it is acceptable to skip schema resolution during write operations (and let the schema of input data be different from the schema of this relation during write)

Default: `false`

See:

* [DataSourceV2Relation](DataSourceV2Relation.md#skipSchemaResolution)

Used when:

* [ResolveReferences](../logical-analysis-rules/ResolveReferences.md) logical resolution rule is executed (for [MergeIntoTable](MergeIntoTable.md) logical operators)
* [ResolveDefaultColumns](../logical-analysis-rules/ResolveDefaultColumns.md) logical resolution rule is executed (to [getSchemaForTargetTable](../logical-analysis-rules/ResolveDefaultColumns.md#getSchemaForTargetTable))
* `V2WriteCommand` logical command is requested to [outputResolved](V2WriteCommand.md#outputResolved)
* [UpdateTable](UpdateTable.md) logical command is executed (and [skipSchemaResolution](UpdateTable.md#skipSchemaResolution))
* [MergeIntoTable](MergeIntoTable.md) logical command is executed (and [skipSchemaResolution](UpdateTable.md#skipSchemaResolution))

## Implementations

* [DataSourceV2Relation](DataSourceV2Relation.md)
* [DataSourceV2ScanRelation](DataSourceV2ScanRelation.md)
* [UnresolvedRelation](UnresolvedRelation.md)
