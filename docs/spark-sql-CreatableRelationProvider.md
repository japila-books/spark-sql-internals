title: CreatableRelationProvider

# CreatableRelationProvider -- Data Sources That Write Rows Differently Per Save Mode

`CreatableRelationProvider` is the <<contract, abstraction>> of <<implementations, data source providers>> that can <<createRelation, write the rows of a structured query (a DataFrame) differently per save mode>>.

[[contract]]
.CreatableRelationProvider Contract
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| createRelation
a| [[createRelation]]

[source, scala]
----
createRelation(
  sqlContext: SQLContext,
  mode: SaveMode,
  parameters: Map[String, String],
  data: DataFrame): BaseRelation
----

Creates a <<spark-sql-BaseRelation.md#, BaseRelation>> that represents the rows of a structured query (a DataFrame) saved to an external data source (per <<spark-sql-DataFrameWriter.md#SaveMode, SaveMode>>)

The save mode specifies what should happen when the target relation (destination) already exists.

Used when:

* `DataSource` is requested to <<spark-sql-DataSource.md#writeAndRead, write data to a data source per save mode followed by reading the rows back>> (when <<spark-sql-LogicalPlan-CreateDataSourceTableAsSelectCommand.md#, CreateDataSourceTableAsSelectCommand>> logical command is executed)

* <<spark-sql-LogicalPlan-SaveIntoDataSourceCommand.md#, SaveIntoDataSourceCommand>> logical command is executed

|===

[[implementations]]
.CreatableRelationProviders
[cols="30,70",options="header",width="100%"]
|===
| CreatableRelationProvider
| Description

| <<spark-sql-ConsoleSinkProvider.md#, ConsoleSinkProvider>>
| [[ConsoleSinkProvider]] Data source provider for <<spark-sql-console.md#, Console data source>>

| <<spark-sql-JdbcRelationProvider.md#, JdbcRelationProvider>>
| [[JdbcRelationProvider]] Data source provider for <<spark-sql-jdbc.md#, JDBC data source>>

| <<spark-sql-KafkaSourceProvider.md#, KafkaSourceProvider>>
| [[KafkaSourceProvider]] Data source provider for <<spark-sql-kafka.md#, Kafka data source>>

|===
