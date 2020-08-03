title: InsertableRelation

# InsertableRelation -- Relations with Inserting or Overwriting Data Support

`InsertableRelation` is an <<contract, abstraction>> of <<implementations, BaseRelations>> that support <<insert, inserting or overwriting data>>.

NOTE: InsertIntoTable.md[InsertIntoTable] unary logical operator is used to insert into an `InsertableRelation`.

[[contract]]
.InsertableRelation Contract
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| createRelation
a| [[createRelation]]

[source, scala]
----
insert(
  data: DataFrame,
  overwrite: Boolean): Unit
----

Inserts or overwrites data (from the given <<spark-sql-DataFrame.md#, DataFrame>>) into a <<spark-sql-BaseRelation.md#, relation>> per `overwrite` flag

Used when spark-sql-LogicalPlan-InsertIntoDataSourceCommand.md[InsertIntoDataSourceCommand] logical command is executed

|===

[[implementations]]
NOTE: spark-sql-JDBCRelation.md[JDBCRelation] is the one and only known direct implementation of <<contract, InsertableRelation Contract>> in Spark SQL.
