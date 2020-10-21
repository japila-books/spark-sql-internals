# ScalaUDAF &mdash; Catalyst Expression Adapter for UserDefinedAggregateFunction

`ScalaUDAF` is a [Catalyst expression](Expression.md) adapter to manage the lifecycle of [UserDefinedAggregateFunction](#udaf) and hook it to Catalyst execution path.

`ScalaUDAF` is <<creating-instance, created>> when:

* `UserDefinedAggregateFunction` creates a `Column` for a user-defined aggregate function using [all](../UserDefinedAggregateFunction.md#apply) and [distinct](../UserDefinedAggregateFunction.md#distinct) values (to use the UDAF in [Dataset operators](../spark-sql-dataset-operators.md))

* `UDFRegistration` is requested to UDFRegistration.md#register[register a user-defined aggregate function] (to use the UDAF in SparkSession.md#sql[SQL mode])

`ScalaUDAF` is a [ImperativeAggregate](ImperativeAggregate.md).

[[ImperativeAggregate-methods]]
.ScalaUDAF's ImperativeAggregate Methods
[width="100%",cols="1,2",options="header"]
|===
| Method Name
| Behaviour

| <<initialize, initialize>>
| Requests <<udaf, UserDefinedAggregateFunction>> to [initialize](../UserDefinedAggregateFunction.md#initialize)

| <<merge, merge>>
| Requests <<udaf, UserDefinedAggregateFunction>> to [merge](../UserDefinedAggregateFunction.md#merge)

| <<update, update>>
| Requests <<udaf, UserDefinedAggregateFunction>> to [update](../UserDefinedAggregateFunction.md#update)
|===

[[eval]]
When evaluated, `ScalaUDAF`...FIXME

`ScalaUDAF` has Expression.md#NonSQLExpression[no representation in SQL].

[[properties]]
.ScalaUDAF's Properties
[width="100%",cols="1,2",options="header"]
|===
| Name
| Description

| `aggBufferAttributes`
| [AttributeReferences](../StructType.md#toAttributes) of <<aggBufferSchema, aggBufferSchema>>

| `aggBufferSchema`
| [bufferSchema](../UserDefinedAggregateFunction.md#bufferSchema) of <<udaf, UserDefinedAggregateFunction>>

| `dataType`
| [DataType](../DataType.md) of [UserDefinedAggregateFunction](#udaf)

| `deterministic`
| `deterministic` of <<udaf, UserDefinedAggregateFunction>>

| `inputAggBufferAttributes`
| Copy of <<aggBufferAttributes, aggBufferAttributes>>

| `inputTypes`
| [Data types](../DataType.md) from [inputSchema](../UserDefinedAggregateFunction.md#inputSchema) of [UserDefinedAggregateFunction](#udaf)

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

## Creating Instance

`ScalaUDAF` takes the following to be created:

* [[children]] Children [Catalyst expressions](Expression.md)
* [[udaf]] [UserDefinedAggregateFunction](../UserDefinedAggregateFunction.md)
* [[mutableAggBufferOffset]] `mutableAggBufferOffset` (starting with `0`)
* [[inputAggBufferOffset]] `inputAggBufferOffset` (starting with `0`)

=== [[initialize]] `initialize` Method

[source, scala]
----
initialize(buffer: InternalRow): Unit
----

`initialize` sets the given [InternalRow](../InternalRow.md) as `underlyingBuffer` of <<mutableAggregateBuffer, MutableAggregationBufferImpl>> and requests the <<udaf, UserDefinedAggregateFunction>> to [initialize](../UserDefinedAggregateFunction.md#initialize) (with the <<mutableAggregateBuffer, MutableAggregationBufferImpl>>).

![ScalaUDAF initializes UserDefinedAggregateFunction](../images/spark-sql-ScalaUDAF-initialize.png)

`initialize` is part of the [ImperativeAggregate](ImperativeAggregate.md#initialize) abstraction.

=== [[update]] `update` Method

[source, scala]
----
update(
  mutableAggBuffer: InternalRow,
  inputRow: InternalRow): Unit
----

`update` sets the given [InternalRow](../InternalRow.md) as `underlyingBuffer` of <<mutableAggregateBuffer, MutableAggregationBufferImpl>> and requests the <<udaf, UserDefinedAggregateFunction>> to [update](../UserDefinedAggregateFunction.md#update).

NOTE: `update` uses <<inputProjection, inputProjection>> on the input `input` and converts it using <<inputToScalaConverters, inputToScalaConverters>>.

.ScalaUDAF updates UserDefinedAggregateFunction
image::images/spark-sql-ScalaUDAF-update.png[align="center"]

`update` is part of the [ImperativeAggregate](ImperativeAggregate.md#update) abstraction.

=== [[merge]] `merge` Method

[source, scala]
----
merge(buffer1: InternalRow, buffer2: InternalRow): Unit
----

`merge` first sets:

* `underlyingBuffer` of <<mutableAggregateBuffer, MutableAggregationBufferImpl>> to the input `buffer1`
* `underlyingInputBuffer` of <<inputAggregateBuffer, InputAggregationBuffer>> to the input `buffer2`

`merge` then requests the <<udaf, UserDefinedAggregateFunction>> to [merge](../UserDefinedAggregateFunction.md#merge) (passing in the <<mutableAggregateBuffer, MutableAggregationBufferImpl>> and <<inputAggregateBuffer, InputAggregationBuffer>>).

![ScalaUDAF requests UserDefinedAggregateFunction to merge](../images/spark-sql-ScalaUDAF-merge.png)

`merge` is part of the [ImperativeAggregate](ImperativeAggregate.md#merge) abstraction.
