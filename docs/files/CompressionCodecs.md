# CompressionCodecs

`CompressionCodecs` utility is used to [set Hadoop compression-related configuration properties](#setCodecConfiguration) for `CSV`, `JSON` and `Text` file formats are requested to prepare write.

## Compression Codecs { #shortCompressionCodecNames }

Alias | Class Name
------|-----------
 `none` |
 `uncompressed` |
 `bzip2` | `org.apache.hadoop.io.compress.BZip2Codec`
 `deflate` | `org.apache.hadoop.io.compress.DeflateCodec`
 `gzip` | `org.apache.hadoop.io.compress.GzipCodec`
 `lz4` | `org.apache.hadoop.io.compress.Lz4Codec`
 `snappy` | `org.apache.hadoop.io.compress.SnappyCodec`

## getCodecClassName { #getCodecClassName }

```scala
getCodecClassName(
  name: String): String
```

`getCodecClassName` looks up a codec by `name` in the [known codecs](#shortCompressionCodecNames) and makes sure that it's available on the classpath.

---

`getCodecClassName` is used when:

* `CSVOptions` is requested for `compressionCodec`
* `JSONOptions` is requested for `compressionCodec`
* `TextOptions` is requested for `compressionCodec`

## setCodecConfiguration { #setCodecConfiguration }

```scala
setCodecConfiguration(
  conf: Configuration,
  codec: String): Unit
```

`setCodecConfiguration` sets `mapreduce` compression-related configuration properties in the given `Configuration` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html)) (based on whether `codec` is defined or not).

codec | Configuration Property | Value
------|------------------------|------
defined | mapreduce.output.fileoutputformat.compress | `true`
defined | mapreduce.output.fileoutputformat.compress.type | `BLOCK`
defined | mapreduce.output.fileoutputformat.compress.codec | codec
defined | mapreduce.map.output.compress | `true`
defined | mapreduce.map.output.compress.codec | codec
undefined | mapreduce.output.fileoutputformat.compress | `false`
undefined | mapreduce.map.output.compress | `false`

---

`setCodecConfiguration` is used when:

* `CSVFileFormat` is requested to `prepareWrite` (based on `compression` or `codec` options)
* `JsonFileFormat` is requested to `prepareWrite` (based on `compression` option)
* `TextFileFormat` is requested to `prepareWrite` (based on `compression` option)
* `CSVWrite` is requested to `prepareWrite` (based on `compression` option)
* `JsonWrite` is requested to `prepareWrite` (based on `compression` option)
* `TextWrite` is requested to `prepareWrite` (based on `compression` option)
