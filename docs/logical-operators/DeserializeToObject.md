# DeserializeToObject Unary Logical Operator

[source, scala]
----
case class DeserializeToObject(
  deserializer: Expression,
  outputObjAttr: Attribute,
  child: LogicalPlan) extends UnaryNode with ObjectProducer
----

`DeserializeToObject` is a spark-sql-LogicalPlan.md#UnaryNode[unary logical operator] that takes the input row from the input `child` spark-sql-LogicalPlan.md[logical plan] and turns it into the input `outputObjAttr` spark-sql-Expression-Attribute.md[attribute] using the given `deserializer` expressions/Expression.md[expression].

`DeserializeToObject` is a `ObjectProducer` which produces domain objects as output. ``DeserializeToObject``'s output is a single-field safe row containing the produced object.

`DeserializeToObject` is the result of [CatalystSerde.deserialize](../CatalystSerde.md#deserialize).
