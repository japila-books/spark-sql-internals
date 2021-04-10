# ScalaReflection

`ScalaReflection` is the contract and the only implementation of the contract with...FIXME

=== [[serializerFor]] `serializerFor` Object Method

[source, scala]
----
serializerFor[T : TypeTag](inputObject: Expression): CreateNamedStruct
----

`serializerFor` firstly finds the <<localTypeOf, local type of>> the input type `T` and then the <<getClassNameFromType, class name>>.

`serializerFor` uses the <<serializerFor-internal, internal version of itself>> with the input `inputObject` expression, the `tpe` type and the `walkedTypePath` with the class name found earlier (of the input type `T`).

```
- root class: "[clsName]"
```

In the end, `serializerFor` returns one of the following:

* The <<spark-sql-Expression-CreateNamedStruct.md#, CreateNamedStruct>> expression from the false value of the `If` expression returned only if the type `T` is <<definedByConstructorParams, definedByConstructorParams>>

* Creates a <<spark-sql-Expression-CreateNamedStruct.md#creating-instance, CreateNamedStruct>> expression with the <<spark-sql-Expression-Literal.md#, Literal>> with the <<spark-sql-Expression-Literal.md#apply, value>> as `"value"` and the expression returned

[source, scala]
----
import org.apache.spark.sql.functions.lit
val inputObject = lit(1).expr

import org.apache.spark.sql.catalyst.ScalaReflection
val serializer = ScalaReflection.serializerFor(inputObject)
scala> println(serializer)
named_struct(value, 1)
----

NOTE: `serializerFor` is used when...FIXME

==== [[serializerFor-internal]] `serializerFor` Internal Method

[source, scala]
----
serializerFor(
  inputObject: Expression,
  tpe: `Type`,
  walkedTypePath: Seq[String],
  seenTypeSet: Set[`Type`] = Set.empty): Expression
----

`serializerFor`...FIXME

NOTE: `serializerFor` is used exclusively when `ScalaReflection` is requested to <<serializerFor, serializerFor>>.

=== [[serializerFor]][[ScalaReflection-serializerFor]] Creating Serialize Expression -- `ScalaReflection.serializerFor` Method

[source, scala]
----
serializerFor[T: TypeTag](inputObject: Expression): CreateNamedStruct
----

`serializerFor` creates a <<spark-sql-Expression-CreateNamedStruct.md#creating-instance, CreateNamedStruct>> expression to serialize a Scala object of type `T` to [InternalRow](InternalRow.md).

```text
import org.apache.spark.sql.catalyst.ScalaReflection.serializerFor

import org.apache.spark.sql.catalyst.expressions.BoundReference
import org.apache.spark.sql.types.TimestampType
val boundRef = BoundReference(ordinal = 0, dataType = TimestampType, nullable = true)

val timestampSerExpr = serializerFor[java.sql.Timestamp](boundRef)
scala> println(timestampSerExpr.numberedTreeString)
00 named_struct(value, input[0, timestamp, true])
01 :- value
02 +- input[0, timestamp, true]
```

Internally, `serializerFor` calls the recursive internal variant of <<serializerFor-recursive, serializerFor>> with a single-element walked type path with `- root class: "[clsName]"` and _pattern match_ on the result expressions/Expression.md[expression].

CAUTION: FIXME the pattern match part

TIP: Read up on Scala's `TypeTags` in http://docs.scala-lang.org/overviews/reflection/typetags-manifests.html[TypeTags and Manifests].

NOTE: `serializerFor` is used exclusively when `ExpressionEncoder` <<creating-instance, is created>> for a Scala type `T`.

==== [[serializerFor-recursive]] Recursive Internal `serializerFor` Method

[source, scala]
----
serializerFor(
  inputObject: Expression,
  tpe: `Type`,
  walkedTypePath: Seq[String],
  seenTypeSet: Set[`Type`] = Set.empty): Expression
----

`serializerFor` creates an expressions/Expression.md[expression] for serializing an object of type `T` to an internal row.

CAUTION: FIXME

=== [[deserializerFor]][[ScalaReflection-deserializerFor]] Creating Deserialize Expression -- `ScalaReflection.deserializerFor` Method

[source, scala]
----
deserializerFor[T: TypeTag]: Expression
----

`deserializerFor` creates an expressions/Expression.md[expression] to deserialize from [InternalRow](InternalRow.md) to a Scala object of type `T`.

```text
import org.apache.spark.sql.catalyst.ScalaReflection.deserializerFor
val timestampDeExpr = deserializerFor[java.sql.Timestamp]
scala> println(timestampDeExpr.numberedTreeString)
00 staticinvoke(class org.apache.spark.sql.catalyst.util.DateTimeUtils$, ObjectType(class java.sql.Timestamp), toJavaTimestamp, upcast(getcolumnbyordinal(0, TimestampType), TimestampType, - root class: "java.sql.Timestamp"), true)
01 +- upcast(getcolumnbyordinal(0, TimestampType), TimestampType, - root class: "java.sql.Timestamp")
02    +- getcolumnbyordinal(0, TimestampType)

val tuple2DeExpr = deserializerFor[(java.sql.Timestamp, Double)]
scala> println(tuple2DeExpr.numberedTreeString)
00 newInstance(class scala.Tuple2)
01 :- staticinvoke(class org.apache.spark.sql.catalyst.util.DateTimeUtils$, ObjectType(class java.sql.Timestamp), toJavaTimestamp, upcast(getcolumnbyordinal(0, TimestampType), TimestampType, - field (class: "java.sql.Timestamp", name: "_1"), - root class: "scala.Tuple2"), true)
02 :  +- upcast(getcolumnbyordinal(0, TimestampType), TimestampType, - field (class: "java.sql.Timestamp", name: "_1"), - root class: "scala.Tuple2")
03 :     +- getcolumnbyordinal(0, TimestampType)
04 +- upcast(getcolumnbyordinal(1, DoubleType), DoubleType, - field (class: "scala.Double", name: "_2"), - root class: "scala.Tuple2")
05    +- getcolumnbyordinal(1, DoubleType)
```

Internally, `deserializerFor` calls the recursive internal variant of <<deserializerFor-recursive, deserializerFor>> with a single-element walked type path with `- root class: "[clsName]"`

!!! tip
    Read up on Scala's `TypeTags` in [TypeTags and Manifests](http://docs.scala-lang.org/overviews/reflection/typetags-manifests.html).

NOTE: `deserializerFor` is used exclusively when `ExpressionEncoder` <<creating-instance, is created>> for a Scala type `T`.

=== [[localTypeOf]] `localTypeOf` Object Method

[source, scala]
----
localTypeOf[T: TypeTag]: `Type`
----

`localTypeOf`...FIXME

[source, scala]
----
import org.apache.spark.sql.catalyst.ScalaReflection
val tpe = ScalaReflection.localTypeOf[Int]
scala> :type tpe
org.apache.spark.sql.catalyst.ScalaReflection.universe.Type

scala> println(tpe)
Int
----

NOTE: `localTypeOf` is used when...FIXME

=== [[getClassNameFromType]] `getClassNameFromType` Object Method

[source, scala]
----
getClassNameFromType(tpe: `Type`): String
----

`getClassNameFromType`...FIXME

[source, scala]
----
import org.apache.spark.sql.catalyst.ScalaReflection
val tpe = ScalaReflection.localTypeOf[java.time.LocalDateTime]
val className = ScalaReflection.getClassNameFromType(tpe)
scala> println(className)
java.time.LocalDateTime
----

NOTE: `getClassNameFromType` is used when...FIXME

=== [[definedByConstructorParams]] `definedByConstructorParams` Object Method

[source, scala]
----
definedByConstructorParams(tpe: Type): Boolean
----

`definedByConstructorParams`...FIXME

NOTE: `definedByConstructorParams` is used when...FIXME
