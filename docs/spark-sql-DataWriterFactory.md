# DataWriterFactory

`DataWriterFactory` is a <<contract, contract>>...FIXME

[[contract]]
[source, java]
----
package org.apache.spark.sql.sources.v2.writer;

public interface DataWriterFactory<T> extends Serializable {
  DataWriter<T> createDataWriter(int partitionId, int attemptNumber);
}
----

[NOTE]
====
`DataWriterFactory` is an `Evolving` contract that is evolving towards becoming a stable API, but is not a stable API yet and can change from one feature release to another release.

In other words, using the contract is as treading on thin ice.
====

.DataWriterFactory Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| [[createDataWriter]] `createDataWriter`
a| Gives the spark-sql-DataWriter.md[DataWriter] for a partition ID and attempt number

Used when:

* `InternalRowDataWriterFactory` is requested to spark-sql-InternalRowDataWriterFactory.md#createDataWriter[createDataWriter]

* `DataWritingSparkTask` is requested to spark-sql-DataWritingSparkTask.md#run[run] and spark-sql-DataWritingSparkTask.md#runContinuous[runContinuous]
|===
