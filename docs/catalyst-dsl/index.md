# Catalyst DSL

**Catalyst DSL** is a collection of Scala implicit conversions for constructing Catalyst data structures more easily.

The goal of Catalyst DSL is to make working with Spark SQL's building blocks easier (e.g. for testing or Spark SQL internals exploration).

## <span id="ExpressionConversions"> ExpressionConversions

Creates Catalyst expressions:

* Literals
* UnresolvedAttribute and UnresolvedReference
* ...

### Type Conversions to Literal Expressions

`ExpressionConversions` adds conversions of Scala native types (e.g. `Boolean`, `Long`, `String`, `Date`, `Timestamp`) and Spark SQL types (i.e. `Decimal`) to [Literal](../expressions/Literal.md) expressions.

### Converting Symbols to UnresolvedAttribute and AttributeReference Expressions

`ExpressionConversions` adds conversions of Scala's `Symbol` to [UnresolvedAttribute](../expressions/UnresolvedAttribute.md) and `AttributeReference` expressions.

### Converting $-Prefixed String Literals to UnresolvedAttribute Expressions

`ExpressionConversions` adds conversions of `$"col name"` to an [UnresolvedAttribute](../expressions/UnresolvedAttribute.md) expression.

### <span id="at"> at

```scala
at(
  ordinal: Int): BoundReference
```

`ExpressionConversions` adds `at` method to `AttributeReferences` to create a [BoundReference](../expressions/BoundReference.md) expression.

```text
import org.apache.spark.sql.catalyst.dsl.expressions._
val boundRef = 'hello.string.at(4)
scala> println(boundRef)
input[4, string, true]
```

### <span id="star"> star

```scala
star(names: String*): Expression
```

`ExpressionConversions` adds the aggregate and non-aggregate functions to [Catalyst expressions](../expressions/Expression.md) (e.g. `sum`, `count`, `upper`, `star`, `callFunction`, `windowSpec`, `windowExpr`)

```text
import org.apache.spark.sql.catalyst.dsl.expressions._
val s = star()

import org.apache.spark.sql.catalyst.analysis.UnresolvedStar
assert(s.isInstanceOf[UnresolvedStar])

val s = star("a", "b")
scala> println(s)
WrappedArray(a, b).*
```

### <span id="function"><span id="distinctFunction"> function and distinctFunction

`ExpressionConversions` allows creating [UnresolvedFunction](../expressions/UnresolvedFunction.md) expressions with `function` and `distinctFunction` operators.

```scala
function(exprs: Expression*): UnresolvedFunction
distinctFunction(exprs: Expression*): UnresolvedFunction
```

```text
import org.apache.spark.sql.catalyst.dsl.expressions._

// Works with Scala Symbols only
val f = 'f.function()
scala> :type f
org.apache.spark.sql.catalyst.analysis.UnresolvedFunction

scala> f.isDistinct
res0: Boolean = false

val g = 'g.distinctFunction()
scala> g.isDistinct
res1: Boolean = true
```

### <span id="DslAttribute"><span id="notNull"><span id="canBeNull"> notNull and canBeNull

`ExpressionConversions` adds `canBeNull` and `notNull` operators to create a `AttributeReference` with `nullability` turned on or off, respectively.

```scala
notNull: AttributeReference
canBeNull: AttributeReference
```

## <span id="ImplicitOperators"> ImplicitOperators

Adds operators to [Catalyst expressions](../expressions/Expression.md) for complex expressions

## <span id="plans"> Implicit Conversions for Logical Plans

```scala
import org.apache.spark.sql.catalyst.dsl.plans._
```

### <span id="DslLogicalPlan"> DslLogicalPlan

[DslLogicalPlan](DslLogicalPlan.md)

### <span id="table"> table

`table` creates a `UnresolvedRelation` logical operator.

```scala
table(
  ref: String): LogicalPlan
table(
  db: String,
  ref: String): LogicalPlan
```

```text
import org.apache.spark.sql.catalyst.dsl.plans._

val t1 = table("t1")
scala> println(t1.treeString)
'UnresolvedRelation `t1`
```

## Package Object

Catalyst DSL is part of `org.apache.spark.sql.catalyst.dsl` package object.

```text
import org.apache.spark.sql.catalyst.dsl.expressions._
```

## spark-shell

Some implicit conversions from the Catalyst DSL interfere with the implicits conversions from `SQLImplicits` that are imported automatically in `spark-shell` (through `spark.implicits._`).

```text
scala> 'hello.decimal
<console>:30: error: type mismatch;
 found   : Symbol
 required: ?{def decimal: ?}
Note that implicit conversions are not applicable because they are ambiguous:
 both method symbolToColumn in class SQLImplicits of type (s: Symbol)org.apache.spark.sql.ColumnName
 and method DslSymbol in trait ExpressionConversions of type (sym: Symbol)org.apache.spark.sql.catalyst.dsl.expressions.DslSymbol
 are possible conversion functions from Symbol to ?{def decimal: ?}
       'hello.decimal
       ^
<console>:30: error: value decimal is not a member of Symbol
       'hello.decimal
              ^
```

Use `sbt console` with Spark libraries defined (in `build.sbt`) instead.

You can also disable an implicit conversion using a trick described in [How can an implicit be unimported from the Scala repl?](https://stackoverflow.com/q/15592324/1305344).

```text
// HACK: Disable symbolToColumn implicit conversion
// It is imported automatically in spark-shell (and makes demos impossible)
// implicit def symbolToColumn(s: Symbol): org.apache.spark.sql.ColumnName
trait ThatWasABadIdea
implicit def symbolToColumn(ack: ThatWasABadIdea) = ack

// HACK: Disable $ string interpolator
// It is imported automatically in spark-shell (and makes demos impossible)
implicit class StringToColumn(val sc: StringContext) {}
```

## Demo

```text
import org.apache.spark.sql.catalyst.dsl.expressions._
import org.apache.spark.sql.catalyst.dsl.plans._

// ExpressionConversions

import org.apache.spark.sql.catalyst.expressions.Literal
scala> val trueLit: Literal = true
trueLit: org.apache.spark.sql.catalyst.expressions.Literal = true

import org.apache.spark.sql.catalyst.analysis.UnresolvedAttribute
scala> val name: UnresolvedAttribute = 'name
name: org.apache.spark.sql.catalyst.analysis.UnresolvedAttribute = 'name

// NOTE: This conversion may not work, e.g. in spark-shell
// There is another implicit conversion StringToColumn in SQLImplicits
// It is automatically imported in spark-shell
// See :imports
val id: UnresolvedAttribute = $"id"

import org.apache.spark.sql.catalyst.expressions.Expression
scala> val expr: Expression = sum('id)
expr: org.apache.spark.sql.catalyst.expressions.Expression = sum('id)

// implicit class DslSymbol
scala> 'hello.s
res2: String = hello

scala> 'hello.attr
res4: org.apache.spark.sql.catalyst.analysis.UnresolvedAttribute = 'hello

// implicit class DslString
scala> "helo".expr
res0: org.apache.spark.sql.catalyst.expressions.Expression = helo

scala> "helo".attr
res1: org.apache.spark.sql.catalyst.analysis.UnresolvedAttribute = 'helo

// logical plans

scala> val t1 = table("t1")
t1: org.apache.spark.sql.catalyst.plans.logical.LogicalPlan =
'UnresolvedRelation `t1`

scala> val p = t1.select('*).serialize[String].where('id % 2 == 0)
p: org.apache.spark.sql.catalyst.plans.logical.LogicalPlan =
'Filter false
+- 'SerializeFromObject [staticinvoke(class org.apache.spark.unsafe.types.UTF8String, StringType, fromString, input[0, java.lang.String, true], true) AS value#1]
   +- 'Project ['*]
      +- 'UnresolvedRelation `t1`

// FIXME Does not work because SimpleAnalyzer's catalog is empty
// the p plan references a t1 table
import org.apache.spark.sql.catalyst.analysis.SimpleAnalyzer
scala> p.analyze
```
