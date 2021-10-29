# MultiInstanceRelation Logical Operators

`MultiInstanceRelation` is an [abstraction](#contract) of [logical operators](#implementations) for which a single instance might appear multiple times in a logical query plan.

## Contract

### <span id="newInstance"> Creating New Instance

```scala
newInstance(): LogicalPlan
```

Used when:

* [ResolveRelations](../logical-analysis-rules/ResolveRelations.md) logical resolution rule is executed
* `DeduplicateRelations` logical resolution rule is executed

## Implementations

* [CTERelationRef](CTERelationRef.md)
* [DataSourceV2Relation](DataSourceV2Relation.md)
* [ExternalRDD](ExternalRDD.md)
* [HiveTableRelation](../hive/HiveTableRelation.md)
* [InMemoryRelation](InMemoryRelation.md)
* [LocalRelation](LocalRelation.md)
* [LogicalRDD](LogicalRDD.md)
* [LogicalRelation](LogicalRelation.md)
* _others_
