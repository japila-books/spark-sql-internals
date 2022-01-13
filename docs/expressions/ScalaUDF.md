# ScalaUDF

`ScalaUDF` is an [Expression](Expression.md) to manage the lifecycle of a [user-defined function](#function) and hook it to Catalyst execution path.

`ScalaUDF` is a `ImplicitCastInputTypes` and `UserDefinedExpression`.

`ScalaUDF` has no representation in SQL.

`ScalaUDF` is <<creating-instance, created>> when:

* `UserDefinedFunction` is UserDefinedFunction.md#apply[executed]

* `UDFRegistration` is requested to UDFRegistration.md#register[register a Scala function as a user-defined function] (in `FunctionRegistry`)

```text
val lengthUDF = udf { s: String => s.length }.withName("lengthUDF")
val c = lengthUDF($"name")
scala> println(c.expr.treeString)
UDF:lengthUDF('name)
+- 'name

import org.apache.spark.sql.catalyst.expressions.ScalaUDF
val scalaUDF = c.expr.asInstanceOf[ScalaUDF]
```

NOTE: [Logical Analyzer](../Analyzer.md) uses [HandleNullInputsForUDF](../logical-analysis-rules/HandleNullInputsForUDF.md) logical evaluation rule to...FIXME

[[deterministic]]
`ScalaUDF` is <<Expression.md#deterministic, deterministic>> when the given <<udfDeterministic, udfDeterministic>> flag is enabled (`true`) and all the <<children, children expressions>> are deterministic.

=== [[doGenCode]] Generating Java Source Code (ExprCode) For Code-Generated Expression Evaluation -- `doGenCode` Method

[source, scala]
----
doGenCode(ctx: CodegenContext, ev: ExprCode): ExprCode
----

NOTE: `doGenCode` is part of <<Expression.md#doGenCode, Expression Contract>> to generate a Java source code (ExprCode) for code-generated expression evaluation.

`doGenCode`...FIXME

=== [[eval]] Evaluating Expression -- `eval` Method

[source, scala]
----
eval(
  input: InternalRow): Any
----

`eval` is part of the [Expression](Expression.md#eval) abstraction.

`eval` executes the <<function, Scala function>> on the input [InternalRow](../InternalRow.md).

## Creating Instance

`ScalaUDF` takes the following when created:

* [[function]] A Scala function (as Scala's `AnyRef`)
* [[dataType]] Output [data type](../types/DataType.md)
* [[children]] Child Expression.md[Catalyst expressions]
* [[inputTypes]] Input [data types](../types/DataType.md) (default: `Nil`)
* [[udfName]] Optional name (default: `None`)
* [[nullable]] `nullable` flag (default: `true`)
* [[udfDeterministic]] `udfDeterministic` flag (default: `true`)

`ScalaUDF` initializes the <<internal-registries, internal registries and counters>>.

## Demo

```text
// Defining a zero-argument UDF
val myUDF = udf { () => "Hello World" }

// "Execute" the UDF
// Attach it to an "execution environment", i.e. a Dataset
// by specifying zero columns to execute on (since the UDF is no-arg)
import org.apache.spark.sql.catalyst.expressions.ScalaUDF
val scalaUDF = myUDF().expr.asInstanceOf[ScalaUDF]

scala> scalaUDF.resolved
res1: Boolean = true

// Execute the UDF (on every row in a Dataset)
// We simulate it relying on the EmptyRow that is the default InternalRow of eval
scala> scalaUDF.eval()
res2: Any = Hello World

// Defining a UDF of one input parameter
val hello = udf { s: String => s"Hello $s" }

// Binding the hello UDF to a column name
import org.apache.spark.sql.catalyst.expressions.ScalaUDF
val helloScalaUDF = hello($"name").expr.asInstanceOf[ScalaUDF]

scala> helloScalaUDF.resolved
res3: Boolean = false

// Resolve helloScalaUDF, i.e. the only `name` column reference

scala> helloScalaUDF.children
res4: Seq[org.apache.spark.sql.catalyst.expressions.Expression] = ArrayBuffer('name)

// The column is free (i.e. not bound to a Dataset)
// Define a Dataset that becomes the rows for the UDF
val names = Seq("Jacek", "Agata").toDF("name")
scala> println(names.queryExecution.analyzed.numberedTreeString)
00 Project [value#1 AS name#3]
01 +- LocalRelation [value#1]

// Resolve the references using the Dataset
val plan = names.queryExecution.analyzed
val resolver = spark.sessionState.analyzer.resolver
import org.apache.spark.sql.catalyst.analysis.UnresolvedAttribute
val resolvedUDF = helloScalaUDF.transformUp { case a @ UnresolvedAttribute(names) =>
  // we're in controlled environment
  // so get is safe
  plan.resolve(names, resolver).get
}

scala> resolvedUDF.resolved
res6: Boolean = true

scala> println(resolvedUDF.numberedTreeString)
00 UDF(name#3)
01 +- name#3: string

import org.apache.spark.sql.catalyst.expressions.BindReferences
val attrs = names.queryExecution.sparkPlan.output
val boundUDF = BindReferences.bindReference(resolvedUDF, attrs)

// Create an internal binary row, i.e. InternalRow
import org.apache.spark.sql.catalyst.encoders.ExpressionEncoder
val stringEncoder = ExpressionEncoder[String]
val row = stringEncoder.toRow("world")

// YAY! It works!
scala> boundUDF.eval(row)
res8: Any = Hello world

// Just to show the regular execution path
// i.e. how to execute a UDF in a context of a Dataset
val q = names.select(hello($"name"))
scala> q.show
+-----------+
|  UDF(name)|
+-----------+
|Hello Jacek|
|Hello Agata|
+-----------+
```
