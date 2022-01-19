# GenerateSafeProjection

`GenerateSafeProjection` utility is a [CodeGenerator](CodeGenerator.md).

```scala
CodeGenerator[Seq[Expression], Projection]
```

`GenerateSafeProjection` is used when:

* `SafeProjection` utility is used to `createCodeGeneratedObject`
* `DeserializeToObjectExec` physical operator is [executed](../physical-operators/DeserializeToObjectExec.md#doExecute)
* `ObjectOperator` utility is used to `deserializeRowToObject`
* `ComplexTypedAggregateExpression` is requested for `inputRowToObj` and `bufferRowToObject`

## <span id="create"> Creating Projection

```scala
create(
  expressions: Seq[Expression]): Projection
```

`create`...FIXME

`create` is part of the [CodeGenerator](CodeGenerator.md#create) abstraction.
