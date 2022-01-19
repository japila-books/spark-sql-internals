# DeserializeToObject

`DeserializeToObject` is a [unary logical operator](LogicalPlan.md#UnaryNode) and a `ObjectProducer`.

## Creating Instance

`DeserializeToObject` takes the following to be created:

* <span id="deserializer"> Deserializer [Expression](../expressions/Expression.md)
* [Attribute](#outputObjAttr)
* <span id="child"> Child [logical operator](LogicalPlan.md)

`DeserializeToObject` is created when:

* `CatalystSerde` utility is used to [create a deserializer (for a logical operator)](../CatalystSerde.md#deserialize)

## <span id="nodePatterns"> Node Patterns

```scala
nodePatterns: Seq[TreePattern]
```

`nodePatterns` is [DESERIALIZE_TO_OBJECT](../catalyst/TreePattern.md#DESERIALIZE_TO_OBJECT).

`nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

## Logical Optimization

`DeserializeToObject` is a target of the following logical optimizations:

* [EliminateSerialization](../logical-optimizations/EliminateSerialization.md)
* [ColumnPruning](../logical-optimizations/ColumnPruning.md)

## Execution Planning

`DeserializeToObject` is planned for execution as [DeserializeToObjectExec](../physical-operators/DeserializeToObjectExec.md) physical operator (by [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy).
