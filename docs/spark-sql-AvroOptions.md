title: Options

# AvroOptions -- Avro Data Source Options

`AvroOptions` represents the <<options, options>> of the <<spark-sql-avro.md#, Avro data source>>.

[[options]]
.Options for Avro Data Source
[cols="1m,1,2",options="header",width="100%"]
|===
| Option / Key
| Default Value
| Description

| avroSchema
| (undefined)
| [[avroSchema]] Avro schema in JSON format

| compression
| (undefined)
a| [[compression]] Specifies the compression codec to use when writing Avro data to disk

!!! note
    If the option is not defined explicitly, Avro data source uses [spark.sql.avro.compression.codec](configuration-properties.md#spark.sql.avro.compression.codec) configuration property.

| ignoreExtension
| `false`
a| [[ignoreExtension]] Controls whether Avro data source should read all Avro files regardless of their extension (`true`) or not (`false`)

By default, Avro data source reads only files with `.avro` file extension.

NOTE: If the option is not defined explicitly, Avro data source uses `avro.mapred.ignore.inputs.without.extension` Hadoop runtime property.

| recordName
| `topLevelRecord`
| [[recordName]] Top-level record name when writing Avro data to disk

Consult https://avro.apache.org/docs/1.8.2/spec.html#schema_record[Apache Avro™ 1.8.2 Specification]

| recordNamespace
| (empty)
| [[recordNamespace]] Record namespace when writing Avro data to disk

Consult https://avro.apache.org/docs/1.8.2/spec.html#schema_record[Apache Avro™ 1.8.2 Specification]
|===

NOTE: The <<options, options>> are case-insensitive.

## Creating Instance

`AvroOptions` takes the following when created:

* [[parameters]] Case-insensitive configuration parameters (i.e. `Map[String, String]`)
* [[conf]] Hadoop https://hadoop.apache.org/docs/r3.1.1/api/org/apache/hadoop/conf/Configuration.html[Configuration]

`AvroOptions` is created when `AvroFileFormat` is requested to [inferSchema](AvroFileFormat.md#inferSchema), [prepareWrite](AvroFileFormat.md#prepareWrite) and [buildReader](AvroFileFormat.md#buildReader).
