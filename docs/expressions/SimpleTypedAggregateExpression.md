# SimpleTypedAggregateExpression

`SimpleTypedAggregateExpression` is...FIXME

`SimpleTypedAggregateExpression` is <<creating-instance, created>> when...FIXME

[[internal-registries]]
.SimpleTypedAggregateExpression's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1m,2",options="header",width="100%"]
|===
| Name
| Description

| evaluateExpression
| [[evaluateExpression]] <<expressions/Expression.md#, Expression>>

| resultObjToRow
| [[resultObjToRow]] <<spark-sql-UnsafeProjection.md#, UnsafeProjection>>
|===

=== [[creating-instance]] Creating SimpleTypedAggregateExpression Instance

`SimpleTypedAggregateExpression` takes the following when created:

* [[aggregator]] spark-sql-Aggregator.md[Aggregator]
* [[inputDeserializer]] Optional input deserializer expressions/Expression.md[expression]
* [[inputClass]] Optional Java class for the input
* [[inputSchema]] Optional spark-sql-StructType.md[schema] for the input
* [[bufferSerializer]] Buffer serializer (as a collection of spark-sql-Expression-NamedExpression.md[named expressions])
* [[bufferDeserializer]] Buffer deserializer expressions/Expression.md[expression]
* [[outputSerializer]] Output serializer (as a collection of expressions/Expression.md[expressions])
* [[dataType]] spark-sql-DataType.md[DataType]
* [[nullable]] `nullable` flag
