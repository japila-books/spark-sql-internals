# CreatableRelationProvider

`CreatableRelationProvider` is an [abstraction](#contract) of [data source providers](#implementations) that can [save data and create a BaseRelation](#createRelation).

## Contract

### <span id="createRelation"> createRelation

```scala
createRelation(
  sqlContext: SQLContext,
  mode: SaveMode,
  parameters: Map[String, String],
  data: DataFrame): BaseRelation
```

Saves the given `DataFrame` to this data source (and creates a [BaseRelation](BaseRelation.md) to represent the relation)

The `SaveMode` specifies what should happen when the target relation (destination) already exists.

Used when:

* `DataSource` is requested to [writeAndRead](DataSource.md#writeAndRead)
* `SaveIntoDataSourceCommand` logical command is requested to [run](logical-operators/SaveIntoDataSourceCommand.md#run)

## Implementations

* `ConsoleSinkProvider`
* [JdbcRelationProvider](datasources/jdbc/JdbcRelationProvider.md)
* [KafkaSourceProvider](kafka/KafkaSourceProvider.md)
