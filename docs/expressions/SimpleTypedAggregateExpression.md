# SimpleTypedAggregateExpression

`SimpleTypedAggregateExpression` is <<creating-instance, created>> when...FIXME

[[internal-registries]]
.SimpleTypedAggregateExpression's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1m,2",options="header",width="100%"]
|===
| Name
| Description

| evaluateExpression
| [[evaluateExpression]] <<Expression.md#, Expression>>

| resultObjToRow
| [[resultObjToRow]] <<spark-sql-UnsafeProjection.md#, UnsafeProjection>>
|===

## Creating Instance

`SimpleTypedAggregateExpression` takes the following when created:

* [[aggregator]] [Aggregator](../Aggregator.md)
* [[inputDeserializer]] Optional input deserializer [expression](Expression.md)
* [[inputClass]] Optional Java class for the input
* [[inputSchema]] Optional [schema](../StructType.md) for the input
* [[bufferSerializer]] Buffer serializer (as a collection of spark-sql-Expression-NamedExpression.md[named expressions])
* [[bufferDeserializer]] Buffer deserializer Expression.md[expression]
* [[outputSerializer]] Output serializer (as a collection of Expression.md[expressions])
* [[dataType]] [DataType](../DataType.md)
* [[nullable]] `nullable` flag
