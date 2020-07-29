title: UnresolvedRelation

# UnresolvedRelation Leaf Logical Operator for Table Reference

[[tableIdentifier]][[creating-instance]]
`UnresolvedRelation` is a spark-sql-LogicalPlan-LeafNode.md[leaf logical operator] to represent a *table reference* in a logical query plan that has yet to be resolved (i.e. looked up in a catalog).

[NOTE]
====
If after spark-sql-Analyzer.md[Analyzer] has finished analyzing a logical query plan the plan has still a `UnresolvedRelation` it spark-sql-Analyzer-CheckAnalysis.md#UnresolvedRelation[fails the analyze phase] with the following `AnalysisException`:

```
Table or view not found: [tableIdentifier]
```
====

`UnresolvedRelation` is <<creating-instance, created>> when:

* `SparkSession` is requested to SparkSession.md#table[create a DataFrame from a table]

* `DataFrameWriter` is requested to spark-sql-DataFrameWriter.md#insertInto[insert a DataFrame into a table]

* `INSERT INTO (TABLE)` or `INSERT OVERWRITE TABLE` SQL commands are InsertIntoTable.md#INSERT_INTO_TABLE[executed]

* hive/CreateHiveTableAsSelectCommand.md[CreateHiveTableAsSelectCommand] logical command is executed

[TIP]
====
Use `table` operator from spark-sql-catalyst-dsl.md#plans[Catalyst DSL] to create a `UnresolvedRelation` logical operator, e.g. for testing or Spark SQL internals exploration.

[source, scala]
----
import org.apache.spark.sql.catalyst.dsl.plans._
val plan = table(db = "myDB", ref = "t1")
scala> println(plan.numberedTreeString)
00 'UnresolvedRelation `myDB`.`t1`
----
====

NOTE: `UnresolvedRelation` is resolved to...FIXME
