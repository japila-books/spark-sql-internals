# InternalRow

`InternalRow` is an [abstraction](#contract) of [binary rows](#implementations).

`InternalRow` is also called *Catalyst row* or *Spark SQL row*.

## Contract

### <span id="copy"> copy

```scala
copy(): InternalRow
```

### <span id="numFields"> numFields

```scala
numFields: Int
```

### <span id="setNullAt"> setNullAt

```scala
setNullAt(
  i: Int): Unit
```

### <span id="update"> update

```scala
update(
  i: Int,
  value: Any): Unit
```

Updates the `value` at column `i`

## Implementations

* BaseGenericInternalRow
* ColumnarBatchRow
* ColumnarRow
* JoinedRow
* MutableColumnarRow
* [UnsafeRow](UnsafeRow.md)

## Serializable

`InternalRow` is a `Serializable` ([Java]({{ java.api }}/java/io/Serializable.html)).

## Demo

```text
// The type of your business objects
case class Person(id: Long, name: String)

// The encoder for Person objects
import org.apache.spark.sql.Encoders
val personEncoder = Encoders.product[Person]

// The expression encoder for Person objects
import org.apache.spark.sql.catalyst.encoders.ExpressionEncoder
val personExprEncoder = personEncoder.asInstanceOf[ExpressionEncoder[Person]]

// Convert Person objects to InternalRow
scala> val row = personExprEncoder.toRow(Person(0, "Jacek"))
row: org.apache.spark.sql.catalyst.InternalRow = [0,0,1800000005,6b6563614a]

// How many fields are available in Person's InternalRow?
scala> row.numFields
res0: Int = 2

// Are there any NULLs in this InternalRow?
scala> row.anyNull
res1: Boolean = false

// You can create your own InternalRow objects
import org.apache.spark.sql.catalyst.InternalRow

scala> val ir = InternalRow(5, "hello", (0, "nice"))
ir: org.apache.spark.sql.catalyst.InternalRow = [5,hello,(0,nice)]
```

```text
import org.apache.spark.sql.catalyst.InternalRow

scala> InternalRow.empty
res0: org.apache.spark.sql.catalyst.InternalRow = [empty row]

scala> InternalRow(0, "string", (0, "pair"))
res1: org.apache.spark.sql.catalyst.InternalRow = [0,string,(0,pair)]

scala> InternalRow.fromSeq(Seq(0, "string", (0, "pair")))
res2: org.apache.spark.sql.catalyst.InternalRow = [0,string,(0,pair)]
```

```text
import org.apache.spark.sql.catalyst.InternalRow
import org.apache.spark.unsafe.types.UTF8String
val demoRow = InternalRow(UTF8String.fromString("demo"))
```

```text
assert(demoRow.getString(0).equals("demo"))
```
