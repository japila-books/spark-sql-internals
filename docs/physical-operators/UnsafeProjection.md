# UnsafeProjection

`UnsafeProjection` is a `Projection` function that encodes [InternalRow](../InternalRow.md)s as [UnsafeRow](../UnsafeRow.md)s.

```text
UnsafeProjection: InternalRow =[apply]=> UnsafeRow
```

[NOTE]
====
Spark SQL uses `UnsafeProjection` factory object to <<create, create>> concrete _adhoc_ `UnsafeProjection` instances.

The base `UnsafeProjection` has no concrete named implementations and <<create, create>> factory methods delegate all calls to spark-sql-GenerateUnsafeProjection.md[GenerateUnsafeProjection.generate] in the end.
====

=== [[create]] Creating UnsafeProjection -- `create` Factory Method

[source, scala]
----
create(schema: StructType): UnsafeProjection      // <1>
create(fields: Array[DataType]): UnsafeProjection // <2>
create(expr: Expression): UnsafeProjection        // <3>
create(exprs: Seq[Expression], inputSchema: Seq[Attribute]): UnsafeProjection // <4>
create(exprs: Seq[Expression]): UnsafeProjection  // <5>
create(
  exprs: Seq[Expression],
  inputSchema: Seq[Attribute],
  subexpressionEliminationEnabled: Boolean): UnsafeProjection
----
<1> `create` takes the [DataTypes](../DataType.md) from `schema` and calls the 2nd `create`
<2> `create` creates a spark-sql-Expression-BoundReference.md[BoundReference] per field in `fields` and calls the 5th `create`
<3> `create` calls the 5th `create`
<4> `create` calls the 5th `create`
<5> The main `create` that does the heavy work

`create` transforms all <<spark-sql-Expression-CreateNamedStruct.md#, CreateNamedStruct>> expressions to `CreateNamedStructUnsafe` in every spark-sql-Expression-BoundReference.md[BoundReference] in the input `exprs`.

In the end, `create` requests `GenerateUnsafeProjection` to spark-sql-GenerateUnsafeProjection.md#generate[generate a UnsafeProjection].

NOTE: A variant of `create` takes `subexpressionEliminationEnabled` flag (that usually is SparkPlan.md#subexpressionEliminationEnabled[subexpressionEliminationEnabled] flag of `SparkPlan`).
