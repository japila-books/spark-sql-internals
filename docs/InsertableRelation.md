# InsertableRelation

`InsertableRelation` is an [abstraction](#contract) of [relations](#implementations) that support [inserting or overwriting data](#insert).

## Contract

### <span id="insert"> Inserting Data into or Overwriting Relation

```scala
insert(
  data: DataFrame,
  overwrite: Boolean): Unit
```

Inserts or overwrites data (from the given [DataFrame](DataFrame.md))

Used when:

* [InsertIntoDataSourceCommand](logical-operators/InsertIntoDataSourceCommand.md) logical command is executed
* [SupportsV1Write](physical-operators/SupportsV1Write.md) physical operator is executed

Used when...FIXME

## Implementations

* [JDBCRelation](datasources/jdbc/JDBCRelation.md)
