title: ScalaUDAF

# ScalaUDAF -- Catalyst Expression Adapter for UserDefinedAggregateFunction

`ScalaUDAF` is a expressions/Expression.md[Catalyst expression] adapter to manage the lifecycle of <<udaf, UserDefinedAggregateFunction>> and hook it in Spark SQL's Catalyst execution path.

`ScalaUDAF` is <<creating-instance, created>> when:

* `UserDefinedAggregateFunction` creates a `Column` for a user-defined aggregate function using spark-sql-UserDefinedAggregateFunction.md#apply[all] and spark-sql-UserDefinedAggregateFunction.md#distinct[distinct] values (to use the UDAF in spark-sql-dataset-operators.md[Dataset operators])

* `UDFRegistration` is requested to UDFRegistration.md#register[register a user-defined aggregate function] (to use the UDAF in SparkSession.md#sql[SQL mode])

`ScalaUDAF` is a spark-sql-Expression-ImperativeAggregate.md[ImperativeAggregate].

[[ImperativeAggregate-methods]]
.ScalaUDAF's ImperativeAggregate Methods
[width="100%",cols="1,2",options="header"]
|===
| Method Name
| Behaviour

| <<initialize, initialize>>
| Requests <<udaf, UserDefinedAggregateFunction>> to spark-sql-UserDefinedAggregateFunction.md#initialize[initialize]

| <<merge, merge>>
| Requests <<udaf, UserDefinedAggregateFunction>> to spark-sql-UserDefinedAggregateFunction.md#merge[merge]

| <<update, update>>
| Requests <<udaf, UserDefinedAggregateFunction>> to spark-sql-UserDefinedAggregateFunction.md#update[update]
|===

[[eval]]
When evaluated, `ScalaUDAF`...FIXME

`ScalaUDAF` has expressions/Expression.md#NonSQLExpression[no representation in SQL].

[[properties]]
.ScalaUDAF's Properties
[width="100%",cols="1,2",options="header"]
|===
| Name
| Description

| `aggBufferAttributes`
| spark-sql-StructType.md#toAttributes[AttributeReferences] of <<aggBufferSchema, aggBufferSchema>>

| `aggBufferSchema`
| spark-sql-UserDefinedAggregateFunction.md#bufferSchema[bufferSchema] of <<udaf, UserDefinedAggregateFunction>>

| `dataType`
| spark-sql-DataType.md[DataType] of <<udaf, UserDefinedAggregateFunction>>

| `deterministic`
| `deterministic` of <<udaf, UserDefinedAggregateFunction>>

| `inputAggBufferAttributes`
| Copy of <<aggBufferAttributes, aggBufferAttributes>>

| `inputTypes`
| spark-sql-DataType.md[Data types] from spark-sql-UserDefinedAggregateFunction.md#inputSchema[inputSchema] of <<udaf, UserDefinedAggregateFunction>>

| `nullable`
| Always enabled (i.e. `true`)
|===

[[internal-registries]]
.ScalaUDAF's Internal Registries and Counters
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| [[inputAggregateBuffer]] `inputAggregateBuffer`
| Used when...FIXME

| [[inputProjection]] `inputProjection`
| Used when...FIXME

| [[inputToScalaConverters]] `inputToScalaConverters`
| Used when...FIXME

| [[mutableAggregateBuffer]] `mutableAggregateBuffer`
| Used when...FIXME
|===

=== [[creating-instance]] Creating ScalaUDAF Instance

`ScalaUDAF` takes the following when created:

* [[children]] Children expressions/Expression.md[Catalyst expressions]
* [[udaf]] spark-sql-UserDefinedAggregateFunction.md[UserDefinedAggregateFunction]
* [[mutableAggBufferOffset]] `mutableAggBufferOffset` (starting with `0`)
* [[inputAggBufferOffset]] `inputAggBufferOffset` (starting with `0`)

`ScalaUDAF` initializes the <<internal-registries, internal registries and counters>>.

=== [[initialize]] `initialize` Method

[source, scala]
----
initialize(buffer: InternalRow): Unit
----

`initialize` sets the input `buffer` spark-sql-InternalRow.md[internal binary row] as `underlyingBuffer` of <<mutableAggregateBuffer, MutableAggregationBufferImpl>> and requests the <<udaf, UserDefinedAggregateFunction>> to spark-sql-UserDefinedAggregateFunction.md#initialize[initialize] (with the <<mutableAggregateBuffer, MutableAggregationBufferImpl>>).

.ScalaUDAF initializes UserDefinedAggregateFunction
image::images/spark-sql-ScalaUDAF-initialize.png[align="center"]

NOTE: `initialize` is part of spark-sql-Expression-ImperativeAggregate.md#initialize[ImperativeAggregate Contract].

=== [[update]] `update` Method

[source, scala]
----
update(mutableAggBuffer: InternalRow, inputRow: InternalRow): Unit
----

`update` sets the input `buffer` spark-sql-InternalRow.md[internal binary row] as `underlyingBuffer` of <<mutableAggregateBuffer, MutableAggregationBufferImpl>> and requests the <<udaf, UserDefinedAggregateFunction>> to spark-sql-UserDefinedAggregateFunction.md#update[update].

NOTE: `update` uses <<inputProjection, inputProjection>> on the input `input` and converts it using <<inputToScalaConverters, inputToScalaConverters>>.

.ScalaUDAF updates UserDefinedAggregateFunction
image::images/spark-sql-ScalaUDAF-update.png[align="center"]

NOTE: `update` is part of spark-sql-Expression-ImperativeAggregate.md#update[ImperativeAggregate Contract].

=== [[merge]] `merge` Method

[source, scala]
----
merge(buffer1: InternalRow, buffer2: InternalRow): Unit
----

`merge` first sets:

* `underlyingBuffer` of <<mutableAggregateBuffer, MutableAggregationBufferImpl>> to the input `buffer1`
* `underlyingInputBuffer` of <<inputAggregateBuffer, InputAggregationBuffer>> to the input `buffer2`

`merge` then requests the <<udaf, UserDefinedAggregateFunction>> to spark-sql-UserDefinedAggregateFunction.md#merge[merge] (passing in the <<mutableAggregateBuffer, MutableAggregationBufferImpl>> and <<inputAggregateBuffer, InputAggregationBuffer>>).

.ScalaUDAF requests UserDefinedAggregateFunction to merge
image::images/spark-sql-ScalaUDAF-merge.png[align="center"]

NOTE: `merge` is part of spark-sql-Expression-ImperativeAggregate.md#merge[ImperativeAggregate Contract].
