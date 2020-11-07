title: CatalystSerde

# CatalystSerde Helper Object

`CatalystSerde` is a Scala object that consists of three utility methods:

. <<deserialize, deserialize>> to create a new logical plan with the input logical plan wrapped inside DeserializeToObject.md[DeserializeToObject] logical operator.
. <<serialize, serialize>>
. <<generateObjAttr, generateObjAttr>>

`CatalystSerde` and belongs to `org.apache.spark.sql.catalyst.plans.logical` package.

=== [[deserialize]] Creating Logical Plan with DeserializeToObject Logical Operator for Logical Plan -- `deserialize` Method

[source, scala]
----
deserialize[T : Encoder](child: LogicalPlan): DeserializeToObject
----

`deserialize` creates a DeserializeToObject.md[`DeserializeToObject` logical operator] for the input `child` spark-sql-LogicalPlan.md[logical plan].

Internally, `deserialize` creates a `UnresolvedDeserializer` for the deserializer for the type `T` first and passes it on to a `DeserializeToObject` with a `AttributeReference` (being the result of <<generateObjAttr, generateObjAttr>>).

=== [[serialize]] `serialize` Method

[source, scala]
----
serialize[T : Encoder](child: LogicalPlan): SerializeFromObject
----

=== [[generateObjAttr]] `generateObjAttr` Method

[source, scala]
----
generateObjAttr[T : Encoder]: Attribute
----
