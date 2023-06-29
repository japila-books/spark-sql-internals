# TreePatternBits

`TreePatternBits` is an [abstraction](#contract) of [tree nodes](#implementations) with the [treePatternBits](#treePatternBits).

## Contract

### Tree Pattern Bits { #treePatternBits }

```scala
treePatternBits: BitSet
```

See:

* [Literal](../expressions/Literal.md#treePatternBits)
* [PlanExpression](../expressions/PlanExpression.md#treePatternBits)
* [QueryPlan](../catalyst/QueryPlan.md#treePatternBits)
* [TreeNode](../catalyst/TreeNode.md#treePatternBits)

Used when:

* `TreePatternBits` is requested to [containsPattern](#containsPattern)

## Implementations

* [TreeNode](TreeNode.md)

## containsPattern { #containsPattern }

```scala
containsPattern(
  t: TreePattern): Boolean
```

`containsPattern` is `true` when the given `TreePattern` is among the [treePatternBits](#treePatternBits).

## containsAnyPattern { #containsAnyPattern }

```scala
containsAnyPattern(
  patterns: TreePattern*): Boolean
```

`containsAnyPattern` checks if any of the given [TreePattern](TreePattern.md)s is a [pattern of this TreeNode](#containsPattern).
