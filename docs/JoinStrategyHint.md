# JoinStrategyHint

`JoinStrategyHint` is an [abstraction](#contract) of join hints.

JoinStrategyHint     | displayName          | hintAliases
---------------------|----------------------|---------
<span id="BROADCAST"> BROADCAST                       | broadcast            | <ul><li>BROADCAST</li><li>BROADCASTJOIN</li><li>MAPJOIN</li></ul>
<span id="NO_BROADCAST_HASH"> NO_BROADCAST_HASH       | no_broadcast_hash    |
<span id="PREFER_SHUFFLE_HASH"> PREFER_SHUFFLE_HASH   | prefer_shuffle_hash  |
<span id="SHUFFLE_HASH"> SHUFFLE_HASH                 | shuffle_hash         | <ul><li>SHUFFLE_HASH</li></ul>
<span id="SHUFFLE_MERGE"> SHUFFLE_MERGE               | merge                | <ul><li>SHUFFLE_MERGE</li><li>MERGE</li><li>MERGEJOIN</li></ul>
<span id="SHUFFLE_REPLICATE_NL"> SHUFFLE_REPLICATE_NL | shuffle_replicate_nl | <ul><li>SHUFFLE_REPLICATE_NL</li></ul>

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

Used when:

* [ResolveJoinStrategyHints](logical-analysis-rules/ResolveJoinStrategyHints.md) logical resolution rule is executed

## <span id="strategies"> JoinStrategyHints

`JoinStrategyHint` defines `strategies` collection of `JoinStrategyHint`s for [ResolveJoinStrategyHints](logical-analysis-rules/ResolveJoinStrategyHints.md#STRATEGY_HINT_NAMES) logical resolution rule:

* [BROADCAST](#BROADCAST)
* [SHUFFLE_MERGE](#SHUFFLE_MERGE)
* [SHUFFLE_HASH](#SHUFFLE_HASH)
* [SHUFFLE_REPLICATE_NL](#SHUFFLE_REPLICATE_NL)
