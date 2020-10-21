# ComplexTypedAggregateExpression

## Creating Instance

`ComplexTypedAggregateExpression` takes the following to be created:

* [[aggregator]] [Aggregator](../Aggregator.md)
* [[inputDeserializer]] Optional input deserializer [expression](Expression.md)
* [[inputClass]] Optional Java class for the input
* [[inputSchema]] Optional [schema](../StructType.md) for the input
* [[bufferSerializer]] Buffer serializer ([NamedExpression](NamedExpression.md)s)
* [[bufferDeserializer]] Buffer deserializer Expression.md[expression]
* [[outputSerializer]] Output serializer ([Expression](Expression.md)s)
* [[dataType]] [DataType](../DataType.md)
* [[nullable]] `nullable` flag
* [[mutableAggBufferOffset]] `mutableAggBufferOffset` (default: `0`)
* [[inputAggBufferOffset]] `inputAggBufferOffset` (default: `0`)
