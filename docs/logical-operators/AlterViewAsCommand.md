title: AlterViewAsCommand

# AlterViewAsCommand Logical Command

`AlterViewAsCommand` is a RunnableCommand.md[logical command] for `ALTER VIEW` SQL statement to alter a view.

`AlterViewAsCommand` works with a table identifier (as `TableIdentifier`), the original SQL text, and a spark-sql-LogicalPlan.md[LogicalPlan] for the SQL query.

## alterViewQuery Labeled Alternative

`AlterViewAsCommand` is described by `alterViewQuery` labeled alternative in `statement` expression in [SqlBase.g4](../sql/AstBuilder.md#grammar) and parsed using [SparkSqlParser](../sql/SparkSqlParser.md).

When <<run, executed>>, `AlterViewAsCommand` attempts to [alter a temporary view in the current `SessionCatalog`](../SessionCatalog.md#alterTempViewDefinition) first, and if that "fails", <<alterPermanentView, alters the permanent view>>.

=== [[run]] Executing Logical Command -- `run` Method

[source, scala]
----
run(session: SparkSession): Seq[Row]
----

NOTE: `run` is part of <<RunnableCommand.md#run, RunnableCommand Contract>> to execute (run) a logical command.

`run`...FIXME

=== [[alterPermanentView]] `alterPermanentView` Internal Method

[source, scala]
----
alterPermanentView(session: SparkSession, analyzedPlan: LogicalPlan): Unit
----

`alterPermanentView`...FIXME

NOTE: `alterPermanentView` is used when...FIXME
