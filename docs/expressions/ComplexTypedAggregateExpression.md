# ComplexTypedAggregateExpression

`ComplexTypedAggregateExpression` is...FIXME

`ComplexTypedAggregateExpression` is <<creating-instance, created>> when...FIXME

=== [[creating-instance]] Creating ComplexTypedAggregateExpression Instance

`ComplexTypedAggregateExpression` takes the following when created:

* [[aggregator]] spark-sql-Aggregator.md[Aggregator]
* [[inputDeserializer]] Optional input deserializer expressions/Expression.md[expression]
* [[inputClass]] Optional Java class for the input
* [[inputSchema]] Optional spark-sql-StructType.md[schema] for the input
* [[bufferSerializer]] Buffer serializer (as a collection of spark-sql-Expression-NamedExpression.md[named expressions])
* [[bufferDeserializer]] Buffer deserializer expressions/Expression.md[expression]
* [[outputSerializer]] Output serializer (as a collection of expressions/Expression.md[expressions])
* [[dataType]] spark-sql-DataType.md[DataType]
* [[nullable]] `nullable` flag
* [[mutableAggBufferOffset]] `mutableAggBufferOffset` (default: `0`)
* [[inputAggBufferOffset]] `inputAggBufferOffset` (default: `0`)
