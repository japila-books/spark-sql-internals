# SaveAsHiveFile

:spark-version: 2.4.5
:hive-version: 2.3.6
:hadoop-version: 2.10.0
:url-hive-javadoc: https://hive.apache.org/javadocs/r{hive-version}/api
:url-hadoop-docs: https://hadoop.apache.org/docs/r{hadoop-version}
:url-hadoop-javadoc: {url-hadoop-docs}/api

`SaveAsHiveFile` is an extension of the ../DataWritingCommand.md[DataWritingCommand] contract for <<implementations, commands>> that can <<saveAsHiveFile, saveAsHiveFile>> (and <<getExternalTmpPath, getExternalTmpPath>>).

[NOTE]
====
`SaveAsHiveFile` supports `viewfs://` URI scheme for <<newVersionExternalTempPath, new Hive versions>>.

Read up on `ViewFs` in the {url-hadoop-docs}/hadoop-project-dist/hadoop-hdfs/ViewFs.html[Hadoop official documentation].
====

[[implementations]]
.SaveAsHiveFiles
[cols="30,70",options="header",width="100%"]
|===
| SaveAsHiveFile
| Description

| InsertIntoHiveDirCommand.md[InsertIntoHiveDirCommand]
| [[InsertIntoHiveDirCommand]]

| InsertIntoHiveTable.md[InsertIntoHiveTable]
| [[InsertIntoHiveTable]]

|===

## <span id="saveAsHiveFile"> saveAsHiveFile

```scala
saveAsHiveFile(
  sparkSession: SparkSession,
  plan: SparkPlan,
  hadoopConf: Configuration,
  fileSinkConf: FileSinkDesc,
  outputLocation: String,
  customPartitionLocations: Map[TablePartitionSpec, String] = Map.empty,
  partitionAttributes: Seq[Attribute] = Nil): Set[String]
```

`saveAsHiveFile` sets Hadoop configuration properties when a compressed file output format is used (based on [hive.exec.compress.output](index.md#hive.exec.compress.output) configuration property).

`saveAsHiveFile` uses `FileCommitProtocol` utility to instantiate a committer for the input `outputLocation` based on the [spark.sql.sources.commitProtocolClass](../configuration-properties.md#spark.sql.sources.commitProtocolClass) configuration property.

`saveAsHiveFile` uses `FileFormatWriter` utility to [write out](../connectors/FileFormatWriter.md#write) the result of executing the input [physical operator](../physical-operators/SparkPlan.md) (with a [HiveFileFormat](HiveFileFormat.md) for the input `FileSinkDesc`, the new `FileCommitProtocol` committer, and the input arguments).

`saveAsHiveFile` is used when [InsertIntoHiveDirCommand](InsertIntoHiveDirCommand.md) and [InsertIntoHiveTable](InsertIntoHiveTable.md) logical commands are executed.

=== [[getExternalTmpPath]] `getExternalTmpPath` Method

[source, scala]
----
getExternalTmpPath(
  sparkSession: SparkSession,
  hadoopConf: Configuration,
  path: Path): Path
----

`getExternalTmpPath` finds the Hive version used. `getExternalTmpPath` requests the input ../SparkSession.md[SparkSession] for the ../SharedState.md#externalCatalog[ExternalCatalog] (that is expected to be a [HiveExternalCatalog](HiveExternalCatalog.md)). `getExternalTmpPath` requests it for the underlying [HiveClient](HiveExternalCatalog.md#client) that is in turn requested for the HiveClient.md#version[Hive version].

`getExternalTmpPath` divides (_splits_) the supported Hive versions into the ones (_old versions_) that use index.md#hive.exec.scratchdir[hive.exec.scratchdir] directory (`0.12.0` to `1.0.0`) and the ones (_new versions_) that use index.md#hive.exec.stagingdir[hive.exec.stagingdir] directory (`1.1.0` to `2.3.3`).

`getExternalTmpPath` <<oldVersionExternalTempPath, oldVersionExternalTempPath>> for the old Hive versions and <<newVersionExternalTempPath, newVersionExternalTempPath>> for the new Hive versions.

`getExternalTmpPath` throws an `IllegalStateException` for unsupported Hive version:

```
Unsupported hive version: [hiveVersion]
```

NOTE: `getExternalTmpPath` is used when InsertIntoHiveDirCommand.md[InsertIntoHiveDirCommand] and InsertIntoHiveTable.md[InsertIntoHiveTable] logical commands are executed.

=== [[deleteExternalTmpPath]] `deleteExternalTmpPath` Method

[source, scala]
----
deleteExternalTmpPath(
  hadoopConf: Configuration): Unit
----

`deleteExternalTmpPath`...FIXME

NOTE: `deleteExternalTmpPath` is used when...FIXME

=== [[oldVersionExternalTempPath]] `oldVersionExternalTempPath` Internal Method

[source, scala]
----
oldVersionExternalTempPath(
  path: Path,
  hadoopConf: Configuration,
  scratchDir: String): Path
----

`oldVersionExternalTempPath`...FIXME

NOTE: `oldVersionExternalTempPath` is used when `SaveAsHiveFile` is requested to <<getExternalTmpPath, getExternalTmpPath>>.

=== [[newVersionExternalTempPath]] `newVersionExternalTempPath` Internal Method

[source, scala]
----
newVersionExternalTempPath(
  path: Path,
  hadoopConf: Configuration,
  stagingDir: String): Path
----

`newVersionExternalTempPath`...FIXME

NOTE: `newVersionExternalTempPath` is used when `SaveAsHiveFile` is requested to <<getExternalTmpPath, getExternalTmpPath>>.

=== [[getExtTmpPathRelTo]] `getExtTmpPathRelTo` Internal Method

[source, scala]
----
getExtTmpPathRelTo(
  path: Path,
  hadoopConf: Configuration,
  stagingDir: String): Path
----

`getExtTmpPathRelTo`...FIXME

NOTE: `getExtTmpPathRelTo` is used when `SaveAsHiveFile` is requested to <<newVersionExternalTempPath, newVersionExternalTempPath>>.

=== [[getExternalScratchDir]] `getExternalScratchDir` Internal Method

[source, scala]
----
getExternalScratchDir(
  extURI: URI,
  hadoopConf: Configuration,
  stagingDir: String): Path
----

`getExternalScratchDir`...FIXME

NOTE: `getExternalScratchDir` is used when `SaveAsHiveFile` is requested to <<newVersionExternalTempPath, newVersionExternalTempPath>>.

=== [[getStagingDir]] `getStagingDir` Internal Method

[source, scala]
----
getStagingDir(
  inputPath: Path,
  hadoopConf: Configuration,
  stagingDir: String): Path
----

`getStagingDir`...FIXME

NOTE: `getStagingDir` is used when `SaveAsHiveFile` is requested to <<getExtTmpPathRelTo, getExtTmpPathRelTo>> and <<getExternalScratchDir, getExternalScratchDir>>.

=== [[executionId]] `executionId` Internal Method

[source, scala]
----
executionId: String
----

`executionId`...FIXME

NOTE: `executionId` is used when...FIXME

=== [[createdTempDir]] `createdTempDir` Internal Registry

[source, scala]
----
createdTempDir: Option[Path] = None
----

`createdTempDir` is a Hadoop {url-hadoop-javadoc}/org/apache/hadoop/fs/Path.html[Path] of a staging directory.

`createdTempDir` is initialized when `SaveAsHiveFile` is requested to <<oldVersionExternalTempPath, oldVersionExternalTempPath>> and <<getStagingDir, getStagingDir>>.

`createdTempDir` is the index.md#hive.exec.stagingdir[hive.exec.stagingdir] configuration property.

`createdTempDir` is deleted when `SaveAsHiveFile` is requested to <<deleteExternalTmpPath, deleteExternalTmpPath>> and at the normal termination of VM (since `deleteOnExit` is used).
