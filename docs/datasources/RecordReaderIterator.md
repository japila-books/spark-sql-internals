# RecordReaderIterator

[[creating-instance]]
[[rowReader]]
`RecordReaderIterator` is a Scala https://www.scala-lang.org/api/2.12.x/scala/collection/Iterator.html[scala.collection.Iterator] over the values of a Hadoop https://hadoop.apache.org/docs/r2.7.3/api/org/apache/hadoop/mapreduce/RecordReader.html[RecordReader].

`RecordReaderIterator` is <<creating-instance, created>> when:

* FIXME

* [HadoopFileLinesReader](HadoopFileLinesReader.md#iterator) and `HadoopFileWholeTextReader` are requested for an value iterator

* Legacy `OrcFileFormat` is requested to `buildReader`

[[close]]
When requested to close, `RecordReaderIterator` simply requests the underlying <<rowReader, RecordReader>> to close.

[[hasNext]]
When requested to check whether or not there more internal rows, `RecordReaderIterator` simply requests the underlying <<rowReader, RecordReader>> for `nextKeyValue`.

[[next]]
When requested for the next internal row, `RecordReaderIterator` simply requests the underlying <<rowReader, RecordReader>> for `getCurrentValue`.
