# RecordReaderIterator

[[creating-instance]]
[[rowReader]]
`RecordReaderIterator` is a Scala https://www.scala-lang.org/api/2.12.x/scala/collection/Iterator.html[scala.collection.Iterator] over the values of a Hadoop https://hadoop.apache.org/docs/r2.7.3/api/org/apache/hadoop/mapreduce/RecordReader.html[RecordReader].

`RecordReaderIterator` is <<creating-instance, created>> when:

* New [OrcFileFormat](orc/OrcFileFormat.md#buildReaderWithPartitionValues) and [ParquetFileFormat](parquet/ParquetFileFormat.md#buildReaderWithPartitionValues) are requested to build a data reader

* [HadoopFileLinesReader](HadoopFileLinesReader.md#iterator) and `HadoopFileWholeTextReader` are requested for an value iterator

* Legacy `OrcFileFormat` is requested to [build a data reader](orc/OrcFileFormat.md#buildReader)

[[close]]
When requested to close, `RecordReaderIterator` simply requests the underlying <<rowReader, RecordReader>> to close.

[[hasNext]]
When requested to check whether or not there more internal rows, `RecordReaderIterator` simply requests the underlying <<rowReader, RecordReader>> for `nextKeyValue`.

[[next]]
When requested for the next internal row, `RecordReaderIterator` simply requests the underlying <<rowReader, RecordReader>> for `getCurrentValue`.
