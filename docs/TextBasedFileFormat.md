# TextBasedFileFormat

`TextBasedFileFormat` is an extension of the [FileFormat](FileFormat.md) contract for <<implementations, formats>> that can be <<isSplitable, splitable>>.

[[implementations]]
.TextBasedFileFormats
[cols="1,2",options="header",width="100%"]
|===
| TextBasedFileFormat
| Description

| [CSVFileFormat](spark-sql-CSVFileFormat.md)
| [[CSVFileFormat]]

| [JsonFileFormat](spark-sql-JsonFileFormat.md)
| [[JsonFileFormat]]

| `LibSVMFileFormat`
| [[LibSVMFileFormat]] Used in Spark MLlib

| [TextFileFormat](TextFileFormat.md)
| [[TextFileFormat]]
|===

[[codecFactory]]
`TextBasedFileFormat` uses Hadoop's https://hadoop.apache.org/docs/current/api/org/apache/hadoop/io/compress/CompressionCodecFactory.html[CompressionCodecFactory] to <<isSplitable, find the proper compression codec for the given file>>.

=== [[isSplitable]] `isSplitable` Method

[source, scala]
----
isSplitable(
  sparkSession: SparkSession,
  options: Map[String, String],
  path: Path): Boolean
----

`isSplitable` is part of [FileFormat](FileFormat.md#isSplitable) abstraction.

`isSplitable` requests the <<codecFactory, CompressionCodecFactory>> to find the ++https://hadoop.apache.org/docs/current/api/org/apache/hadoop/io/compress/CompressionCodecFactory.html#getCodec-org.apache.hadoop.fs.Path-++[compression codec for the given file] (as the input `path`) based on its filename suffix.

`isSplitable` returns `true` when the compression codec is not used (i.e. `null`) or is a Hadoop https://hadoop.apache.org/docs/current/api/org/apache/hadoop/io/compress/SplittableCompressionCodec.html[SplittableCompressionCodec] (e.g. https://hadoop.apache.org/docs/current/api/org/apache/hadoop/io/compress/BZip2Codec.html[BZip2Codec]).

If the <<codecFactory, CompressionCodecFactory>> is not defined, `isSplitable` creates a https://hadoop.apache.org/docs/current/api/org/apache/hadoop/io/compress/CompressionCodecFactory.html[CompressionCodecFactory] (with a Hadoop `Configuration` by requesting the `SessionState` for a SessionState.md#newHadoopConfWithOptions[new Hadoop Configuration with extra options]).

NOTE: `isSplitable` uses the input `sparkSession` to access SparkSession.md#sessionState[SessionState].

[NOTE]
====
https://hadoop.apache.org/docs/current/api/org/apache/hadoop/io/compress/SplittableCompressionCodec.html[SplittableCompressionCodec] interface is for compression codecs that are capable to compress and de-compress a stream starting at any arbitrary position.

Such codecs are highly valuable, especially in the context of Hadoop, because an input compressed file can be split and hence can be worked on by multiple machines in parallel.

One such compression codec is https://hadoop.apache.org/docs/current/api/org/apache/hadoop/io/compress/BZip2Codec.html[BZip2Codec] that provides output and input streams for bzip2 compression and decompression.
====
