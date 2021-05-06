# BaseJoinExec Physical Operators

`BaseJoinExec` is an [extension](#contract) of the [BinaryExecNode](BinaryExecNode.md) abstraction for [join physical operators](#implementations).

## Contract

### <span id="condition"> Join Condition

```scala
condition: Option[Expression]
```

### <span id="joinType"> Join Type

```scala
joinType: JoinType
```

[JoinType](../joins.md#JoinType)

### <span id="leftKeys"> Left Keys

```scala
leftKeys: Seq[Expression]
```

### <span id="rightKeys"> Right Keys

```scala
rightKeys: Seq[Expression]
```

## Implementations

* [BroadcastNestedLoopJoinExec](BroadcastNestedLoopJoinExec.md)
* [CartesianProductExec](CartesianProductExec.md)
* [HashJoin](HashJoin.md)
* [ShuffledJoin](ShuffledJoin.md)
