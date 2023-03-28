# RelationPlugin

`RelationPlugin` is an [abstraction](#contract) of [extensions](#implementations) that can [transform](#transform).

## Contract

### <span id="transform"> transform

```scala
transform(
  relation: protobuf.Any,
  planner: SparkConnectPlanner): Option[LogicalPlan]
```

Used when:

* `SparkConnectPlanner` is requested to [transformRelationPlugin](SparkConnectPlanner.md#transformRelationPlugin)

## Implementations

!!! note
    No built-in implementations available.
