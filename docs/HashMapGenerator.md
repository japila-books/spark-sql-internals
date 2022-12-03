# HashMapGenerator

`HashMapGenerator` is an [abstraction](#contract) of [HashMap generators](#implementations) that can [generate an append-only row-based hash map](#generate) for extremely fast key-value lookups while evaluating aggregates.

## Contract

### <span id="generateEquals"> generateEquals

```scala
generateEquals(): String
```

Used when:

* `HashMapGenerator` is requested to [generate a Java code](#generate)

### <span id="generateFindOrInsert"> generateFindOrInsert

```scala
generateFindOrInsert(): String
```

Used when:

* `HashMapGenerator` is requested to [generate a Java code](#generate)

### <span id="generateRowIterator"> generateRowIterator

```scala
generateRowIterator(): String
```

Used when:

* `HashMapGenerator` is requested to [generate a Java code](#generate)

### <span id="initializeAggregateHashMap"> initializeAggregateHashMap

```scala
initializeAggregateHashMap(): String
```

Used when:

* `HashMapGenerator` is requested to [generate a Java code](#generate)

## Implementations

* `RowBasedHashMapGenerator`
* `VectorizedHashMapGenerator`

## <span id="generate"> Generating Java Code

```scala
generate(): String
```

`generate` creates a source code of a Java class with the following (in that order):

1. [generatedClassName](#generatedClassName)
1. [initializeAggregateHashMap](#initializeAggregateHashMap)
1. [generateFindOrInsert](#generateFindOrInsert)
1. [generateEquals](#generateEquals)
1. [generateHashFunction](#generateHashFunction)
1. [generateRowIterator](#generateRowIterator)
1. [generateClose](#generateClose)

---

`generate` is used when:

* `HashAggregateExec` physical operator is requested to [doProduceWithKeys](physical-operators/HashAggregateExec.md#doProduceWithKeys)
