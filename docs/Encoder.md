# Encoder

`Encoder[T]` is an [abstraction](#contract) of [converters](#implementations) that can convert JVM objects (of type `T`) to and from the internal Spark SQL representation ([InternalRow](InternalRow.md)).

`Encoder`s are `Serializable` ([Java]({{ java.api }}/java.base/java/io/Serializable.html)).

`Encoder` is the fundamental concept in the **Serialization and Deserialization (SerDe) Framework**. Spark SQL uses the SerDe framework for IO to make it efficient time- and space-wise.

!!! note
    Spark has borrowed the idea from the [Hive SerDe library](https://cwiki.apache.org/confluence/display/Hive/SerDe) so it might be worthwhile to get familiar with Hive a little bit, too.

`Encoder` is also called _"a container of serde expressions in Dataset"_.

`Encoder` is a part of [Dataset](Dataset.md)s (to serialize and deserialize the records of this dataset).

`Encoder` knows the [schema](#schema) of the records and that is how they offer significantly faster serialization and deserialization (comparing to the default Java or Kryo serializers).

Custom `Encoder`s are created using [Encoders](Encoders.md) utility. `Encoder`s for common Scala types and their product types are already available in [implicits](SparkSession.md#implicits) object.

```scala
val spark = SparkSession.builder.getOrCreate()
import spark.implicits._
```

!!! TIP
    The default encoders are already imported in `spark-shell`.

`Encoder`s map columns (of your dataset) to fields (of your JVM object) by name. It is by `Encoder`s that you can bridge JVM objects to data sources (CSV, JDBC, Parquet, Avro, JSON, Cassandra, Elasticsearch, memsql) and vice versa.

## Contract

### <span id="clsTag"> ClassTag

```scala
clsTag: ClassTag[T]
```

`ClassTag` ([Scala]({{ scala.api }}/scala/reflect/ClassTag.html)) for creating Arrays of `T`s

Used when:

* `AppendColumns` utility is used to create a `AppendColumns`
* `MapElements` utility is used to create a `MapElements`
* `TypedFilter` utility is used to create a `TypedFilter`
* `TypedColumn` is requested to [withInputType](TypedColumn.md#withInputType)

### <span id="schema"> Schema

```scala
schema: StructType
```

[Schema](StructType.md) of encoding this type of object as a [Row](Row.md)

## Implementations

* [ExpressionEncoder](ExpressionEncoder.md)

## Demo

```text
// The domain object for your records in a large dataset
case class Person(id: Long, name: String)

import org.apache.spark.sql.Encoders

scala> val personEncoder = Encoders.product[Person]
personEncoder: org.apache.spark.sql.Encoder[Person] = class[id[0]: bigint, name[0]: string]

scala> personEncoder.schema
res0: org.apache.spark.sql.types.StructType = StructType(StructField(id,LongType,false), StructField(name,StringType,true))

scala> personEncoder.clsTag
res1: scala.reflect.ClassTag[Person] = Person

import org.apache.spark.sql.catalyst.encoders.ExpressionEncoder

scala> val personExprEncoder = personEncoder.asInstanceOf[ExpressionEncoder[Person]]
personExprEncoder: org.apache.spark.sql.catalyst.encoders.ExpressionEncoder[Person] = class[id[0]: bigint, name[0]: string]

// ExpressionEncoders may or may not be flat
scala> personExprEncoder.flat
res2: Boolean = false

// The Serializer part of the encoder
scala> personExprEncoder.serializer
res3: Seq[org.apache.spark.sql.catalyst.expressions.Expression] = List(assertnotnull(input[0, Person, true], top level non-flat input object).id AS id#0L, staticinvoke(class org.apache.spark.unsafe.types.UTF8String, StringType, fromString, assertnotnull(input[0, Person, true], top level non-flat input object).name, true) AS name#1)

// The Deserializer part of the encoder
scala> personExprEncoder.deserializer
res4: org.apache.spark.sql.catalyst.expressions.Expression = newInstance(class Person)

scala> personExprEncoder.namedExpressions
res5: Seq[org.apache.spark.sql.catalyst.expressions.NamedExpression] = List(assertnotnull(input[0, Person, true], top level non-flat input object).id AS id#2L, staticinvoke(class org.apache.spark.unsafe.types.UTF8String, StringType, fromString, assertnotnull(input[0, Person, true], top level non-flat input object).name, true) AS name#3)

// A record in a Dataset[Person]
// A mere instance of Person case class
// There could be a thousand of Person in a large dataset
val jacek = Person(0, "Jacek")

// Serialize a record to the internal representation, i.e. InternalRow
scala> val row = personExprEncoder.toRow(jacek)
row: org.apache.spark.sql.catalyst.InternalRow = [0,0,1800000005,6b6563614a]

// Spark uses InternalRows internally for IO
// Let's deserialize it to a JVM object, i.e. a Scala object
import org.apache.spark.sql.catalyst.dsl.expressions._

// in spark-shell there are competing implicits
// That's why DslSymbol is used explicitly in the following line
scala> val attrs = Seq(DslSymbol('id).long, DslSymbol('name).string)
attrs: Seq[org.apache.spark.sql.catalyst.expressions.AttributeReference] = List(id#8L, name#9)

scala> val jacekReborn = personExprEncoder.resolveAndBind(attrs).fromRow(row)
jacekReborn: Person = Person(0,Jacek)

// Are the jacek instances same?
scala> jacek == jacekReborn
res6: Boolean = true
```

```scala
val toRow = personExprEncoder.createSerializer()
toRow(jacek)
```

```scala
val fromRow = personExprEncoder.resolveAndBind().createDeserializer()
val jacekReborn = fromRow(row)
```

## Further Reading and Watching

* (video) [Modern Spark DataFrame and Dataset (Intermediate Tutorial)](https://youtu.be/_1byVWTEK1s) by [Adam Breindel](https://twitter.com/adbreind)
