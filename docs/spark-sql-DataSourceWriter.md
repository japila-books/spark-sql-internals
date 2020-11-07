# DataSourceWriter

`DataSourceWriter` is the <<contract, abstraction>> of <<implementations, data source writers>> in [DataSource V2](new-and-noteworthy/datasource-v2.md) that can <<abort, abort>> or <<commit, commit>> a writing Spark job, <<createWriterFactory, create a DataWriterFactory>> to be shared among writing Spark tasks and optionally <<onDataWriterCommit, handle a commit message>> and <<useCommitCoordinator, use a CommitCoordinator>> for writing Spark tasks.

NOTE: The terms *Spark job* and *Spark task* are really about the low-level Spark jobs and tasks (that you can monitor using web UI for example).

`DataSourceWriter` is used to create a logical <<WriteToDataSourceV2.md#, WriteToDataSourceV2>> and physical <<WriteToDataSourceV2Exec.md#, WriteToDataSourceV2Exec>> operators.

`DataSourceWriter` is created when:

* `DataSourceV2Relation` logical operator is requested to <<DataSourceV2Relation.md#newWriter, create one>>

* `WriteSupport` data source is requested to <<spark-sql-WriteSupport.md#createWriter, create one>>

[[contract]]
.DataSourceWriter Contract
[cols="1m,3",options="header",width="100%"]
|===
| Method
| Description

| abort
a| [[abort]]

[source, java]
----
void abort(WriterCommitMessage[] messages)
----

Aborts a writing Spark job

Used exclusively when `WriteToDataSourceV2Exec` physical operator is requested to <<WriteToDataSourceV2Exec.md#doExecute, execute>> (and an exception was reported)

| commit
a| [[commit]]

[source, java]
----
void commit(WriterCommitMessage[] messages)
----

Commits a writing Spark job

Used exclusively when `WriteToDataSourceV2Exec` physical operator is requested to <<WriteToDataSourceV2Exec.md#doExecute, execute>> (and writing tasks all completed successfully)

| createWriterFactory
a| [[createWriterFactory]]

[source, java]
----
DataWriterFactory<InternalRow> createWriterFactory()
----

Creates a <<spark-sql-DataWriterFactory.md#, DataWriterFactory>>

Used when:

* `WriteToDataSourceV2Exec` physical operator is requested to <<WriteToDataSourceV2Exec.md#doExecute, execute>>

* Spark Structured Streaming's `WriteToContinuousDataSourceExec` physical operator is requested to execute

* Spark Structured Streaming's `MicroBatchWriter` is requested to create a `DataWriterFactory`

| onDataWriterCommit
a| [[onDataWriterCommit]]

[source, java]
----
void onDataWriterCommit(WriterCommitMessage message)
----

Handles `WriterCommitMessage` commit message for a single successful writing Spark task

Defaults to _do nothing_

Used exclusively when `WriteToDataSourceV2Exec` physical operator is requested to <<WriteToDataSourceV2Exec.md#doExecute, execute>> (and runs a Spark job with partition writing tasks)

| useCommitCoordinator
a| [[useCommitCoordinator]]

[source, java]
----
boolean useCommitCoordinator()
----

Controls whether to use a Spark Core `OutputCommitCoordinator` (`true`) or not (`false`) for data writing (to make sure that at most one task for a partition commits)

Default: `true`

Used exclusively when `WriteToDataSourceV2Exec` physical operator is requested to <<WriteToDataSourceV2Exec.md#doExecute, execute>>

|===

[[implementations]]
.DataSourceWriters (Direct Implementations and Extensions)
[cols="1m,3",options="header",width="100%"]
|===
| DataSourceWriter
| Description

| MicroBatchWriter
| [[MicroBatchWriter]] Used in Spark Structured Streaming only for https://jaceklaskowski.gitbooks.io/spark-structured-streaming/spark-sql-streaming-micro-batch-processing.html[Micro-Batch Stream Processing]

| StreamWriter
| [[StreamWriter]] Used in Spark Structured Streaming only (to support epochs)

|===
