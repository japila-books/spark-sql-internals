# CTERelationRef Leaf Logical Operator

`CTERelationRef` is a [leaf logical operator](LeafNode.md).

## Creating Instance

`CTERelationRef` takes the following to be created:

* <span id="cteId"> CTE Id
* <span id="_resolved"> `_resolved` flag
* <span id="output"> Output [Attribute](../expressions/Attribute.md)s
* <span id="statsOpt"> Optional [Statistics](Statistics.md) (default: `None`)

`CTERelationRef` is created when:

* [CTESubstitution](../logical-analysis-rules/CTESubstitution.md) logical resolution rule is executed
* [ResolveWithCTE](../logical-analysis-rules/ResolveWithCTE.md) logical resolution rule is executed

## <span id="MultiInstanceRelation"> MultiInstanceRelation

`CTERelationRef` is a [MultiInstanceRelation](MultiInstanceRelation.md).
