# NamedRelation Logical Operators

`NamedRelation` is an [extension](#contract) of the [LogicalPlan](LogicalPlan.md) abstraction for [logical operators](#implementations).

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

Controls whether to skip schema resolution and let the schema of input data be different from the schema of this relation during write (e.g. when a target table accepts any schema)

Default: `false`

Used when:

* [ResolveReferences](../logical-analysis-rules/ResolveReferences.md) logical resolution rule is executed (for [MergeIntoTable](MergeIntoTable.md) logical operators)
* `V2WriteCommand` logical command is requested to [outputResolved](V2WriteCommand.md#outputResolved)

## Implementations

* [DataSourceV2Relation](DataSourceV2Relation.md)
* [DataSourceV2ScanRelation](DataSourceV2ScanRelation.md)
* [UnresolvedRelation](UnresolvedRelation.md)
* `UnresolvedV2Relation`
