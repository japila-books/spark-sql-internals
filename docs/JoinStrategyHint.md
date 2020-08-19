# JoinStrategyHint

`JoinStrategyHint` is an [abstraction](#contract) of join hints.

JoinStrategyHint     | displayName          | hintAliases
---------------------|----------------------|---------
BROADCAST            | broadcast            | BROADCAST, BROADCASTJOIN, MAPJOIN
NO_BROADCAST_HASH    | no_broadcast_hash    |
SHUFFLE_HASH         | shuffle_hash         | SHUFFLE_HASH
SHUFFLE_MERGE        | merge                | SHUFFLE_MERGE, MERGE, MERGEJOIN
SHUFFLE_REPLICATE_NL | shuffle_replicate_nl | SHUFFLE_REPLICATE_NL

`JoinStrategyHint` is resolved using [ResolveJoinStrategyHints](logical-analysis-rules/ResolveJoinStrategyHints.md) logical resolution rule.

??? note "sealed abstract class"
    `JoinStrategyHint` is a Scala sealed abstract class which means that all possible implementations (`JoinStrategyHint`s) are all in the same compilation unit (file).

## Contract

### <span id="displayName"><span id="toString"> displayName

```scala
displayName: String
```

### <span id="hintAliases"> hintAliases

```scala
hintAliases: Set[String]
```

Used when [ResolveJoinStrategyHints](logical-analysis-rules/ResolveJoinStrategyHints.md) logical resolution rule is executed
