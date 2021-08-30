# TreePatternBits

`TreePatternBits` is an [abstraction](#contract) of [trees](#implementations) with the [treePatternBits](#treePatternBits).

## Contract

### <span id="treePatternBits"> treePatternBits

```scala
treePatternBits: BitSet
```

Used when:

* `TreePatternBits` is requested to [containsPattern](#containsPattern)

## Implementations

* [TreeNode](TreeNode.md)

## <span id="containsPattern"> containsPattern

```scala
containsPattern(
  t: TreePattern): Boolean
```

`containsPattern` is `true` when the given `TreePattern` is among the [treePatternBits](#treePatternBits).
