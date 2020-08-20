# GenericStrategy &mdash; Planning Strategies

`GenericStrategy` is an [abstraction](#contract) of [planning strategies](#implementations) of [QueryPlanner](QueryPlanner.md#strategies).

## Type Constructor and PhysicalPlan Type

`GenericStrategy` is a type constructor in Scala (_generic class_ in Java) with the following definition:

```scala
abstract class GenericStrategy[PhysicalPlan <: TreeNode[PhysicalPlan]]
```

`GenericStrategy` uses `PhysicalPlan` as the name of a type that is a subtype of [TreeNode](TreeNode.md) and for which a concrete class can be created (e.g. [SparkStrategy](../execution-planning-strategies/SparkStrategy.md)).

## Contract

### <span id="apply"> apply

```scala
apply(
  plan: LogicalPlan): Seq[PhysicalPlan]
```

Executes the planning strategy (to generate a [TreeNode](TreeNode.md))

### <span id="planLater"> planLater

```scala
planLater(
  plan: LogicalPlan): PhysicalPlan
```

## Implementations

* [SparkStrategy](../execution-planning-strategies/SparkStrategy.md)
