# ScalaUDF Expression

`ScalaUDF` is an [Expression](Expression.md) to manage the lifecycle of a [user-defined function](#function) (and hook it to Catalyst execution path).

`ScalaUDF` is a `NonSQLExpression` (and so has no representation in SQL).

`ScalaUDF` is a [UserDefinedExpression](UserDefinedExpression.md).

## Creating Instance

`ScalaUDF` takes the following to be created:

* <span id="function"> Function
* <span id="dataType"> [DataType](../types/DataType.md)
* <span id="children"> Child [Expression](Expression.md)s
* <span id="inputEncoders"> Input [ExpressionEncoder](../ExpressionEncoder.md)s
* <span id="outputEncoder"> Output [ExpressionEncoder](../ExpressionEncoder.md)
* <span id="udfName"> Name
* <span id="nullable"> `nullable` flag (default: `true`)
* <span id="udfDeterministic"> `udfDeterministic` flag (default: `true`)

`ScalaUDF` is created when:

* `UDFRegistration` is requested to [register a UDF](../user-defined-functions/UDFRegistration.md#register)
* `BaseDynamicPartitionDataWriter` is requested for [partitionPathExpression](../files/BaseDynamicPartitionDataWriter.md#partitionPathExpression)
* `SparkUserDefinedFunction` is requested to [createScalaUDF](SparkUserDefinedFunction.md#createScalaUDF)

## <span id="deterministic"> deterministic

```scala
deterministic: Boolean
```

`deterministic` is part of the [Expression](Expression.md#deterministic) abstraction.

---

`ScalaUDF` is `deterministic` when all the following hold:

1. [udfDeterministic](#udfDeterministic) is enabled
1. All the [children](#children) are [deterministic](Expression.md#deterministic)

## <span id="toString"> Text Representation

```scala
toString: String
```

`toString` is part of the [TreeNode](../catalyst/TreeNode.md#toString) abstraction.

---

`toString` uses the [name](#name) and the [children] for the text representation:

```text
[name]([comma-separated children])
```

## <span id="name"> Name

```scala
name: String
```

`name` is part of the [UserDefinedExpression](UserDefinedExpression.md#name) abstraction.

---

`name` is the [udfName](#udfName) (if defined) or `UDF`.

## <span id="doGenCode"> Generating Java Source Code for Code-Generated Expression Evaluation

```scala
doGenCode(
  ctx: CodegenContext,
  ev: ExprCode): ExprCode
```

`doGenCode` is part of the [Expression](Expression.md#doGenCode) abstraction.

---

`doGenCode` requests the given [CodegenContext](../whole-stage-code-generation/CodegenContext.md) to [register a reference](../whole-stage-code-generation/CodegenContext.md#addReferenceObj) (that gives a `udf` reference):

Input Argument | Value
---------------|-------
 `objName` | `udf`
 `obj` | The given [function](#function)
 `className` | `scala.FunctionN` (where `N` is the number of the given [children](#children))

Since Scala functions are executed using `apply` method, `doGenCode` creates a string with the following source code:

```text
[udf].apply([comma-separated funcArgs])
```

!!! note
    There is more in `doGenCode`.

In the end, `doGenCode` generates a block of a Java code in the following format:

```text
[evalCode]
[initArgs]
[boxedType] [resultTerm] = null;
try {
  [funcInvocation];
} catch (Throwable e) {
  throw QueryExecutionErrors.failedExecuteUserDefinedFunctionError(
    "[funcCls]", "[inputTypesString]", "[outputType]", e);
}


boolean [isNull] = [resultTerm] == null;
[dataType] [value] = [defaultValue];
if (![isNull]) {
  [value] = [resultTerm];
}
```

## <span id="eval"> Interpreted Expression Evaluation

```scala
eval(
  input: InternalRow): Any
```

`eval` is part of the [Expression](Expression.md#eval) abstraction.

---

`eval`...FIXME

## <span id="nodePatterns"> Node Patterns

```scala
nodePatterns: Seq[TreePattern]
```

`nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

---

`nodePatterns` is [SCALA_UDF](../catalyst/TreePattern.md#SCALA_UDF).

## Analysis

[Logical Analyzer](../Analyzer.md) uses `HandleNullInputsForUDF` and `ResolveEncodersInUDF` logical evaluation rules to analyze queries with `ScalaUDF` expressions.

## Demo

### Zero-Argument UDF

Let's define a zero-argument UDF.

```scala
val myUDF = udf { () => "Hello World" }
```

```scala
// "Execute" the UDF
// Attach it to an "execution environment", i.e. a Dataset
// by specifying zero columns to execute on (since the UDF is no-arg)
import org.apache.spark.sql.catalyst.expressions.ScalaUDF
val scalaUDF = myUDF().expr.asInstanceOf[ScalaUDF]

assert(scalaUDF.resolved)
```

Let's execute the UDF (on every row in a `Dataset`).
We simulate it relying on the `EmptyRow` that is the default `InternalRow` of `eval`.

```text
scala> scalaUDF.eval()
res2: Any = Hello World
```

### Whole-Stage Code Gen

```scala
import org.apache.spark.sql.catalyst.expressions.codegen.CodegenContext
val ctx = new CodegenContext
val code = scalaUDF.genCode(ctx).code
```

```text
scala> println(code)
UTF8String result_1 = null;
try {
  result_1 = (UTF8String)((scala.Function1[]) references[2] /* converters */)[0].apply(((scala.Function0) references[3] /* udf */).apply());
} catch (Throwable e) {
  throw QueryExecutionErrors.failedExecuteUserDefinedFunctionError(
    "$read$$iw$$Lambda$2020/0x000000080153ad78", "", "string", e);
}


boolean isNull_1 = result_1 == null;
UTF8String value_1 = null;
if (!isNull_1) {
  value_1 = result_1;
}
```

### One-Argument UDF

Let's define a UDF of one argument.

```scala
val lengthUDF = udf { s: String => s.length }.withName("lengthUDF")
val c = lengthUDF($"name")
```

```text
scala> println(c.expr.treeString)
UDF:lengthUDF('name)
+- 'name
```

```scala
import org.apache.spark.sql.catalyst.expressions.ScalaUDF
assert(c.expr.isInstanceOf[ScalaUDF])
```

Let's define another UDF of one argument.

```text
val hello = udf { s: String => s"Hello $s" }

// Binding the hello UDF to a column name
import org.apache.spark.sql.catalyst.expressions.ScalaUDF
val helloScalaUDF = hello($"name").expr.asInstanceOf[ScalaUDF]

assert(helloScalaUDF.resolved == false)
```

```text
// Resolve helloScalaUDF, i.e. the only `name` column reference

scala> helloScalaUDF.children
res4: Seq[org.apache.spark.sql.catalyst.expressions.Expression] = ArrayBuffer('name)
```

```scala
// The column is free (i.e. not bound to a Dataset)
// Define a Dataset that becomes the rows for the UDF
val names = Seq("Jacek", "Agata").toDF("name")
```

```text
scala> println(names.queryExecution.analyzed.numberedTreeString)
00 Project [value#1 AS name#3]
01 +- LocalRelation [value#1]
```

Resolve the references using the `Dataset`.

```scala
val plan = names.queryExecution.analyzed
val resolver = spark.sessionState.analyzer.resolver
import org.apache.spark.sql.catalyst.analysis.UnresolvedAttribute
val resolvedUDF = helloScalaUDF.transformUp { case a @ UnresolvedAttribute(names) =>
  // we're in controlled environment
  // so get is safe
  plan.resolve(names, resolver).get
}
assert(resolvedUDF.resolved)
```

```text
scala> println(resolvedUDF.numberedTreeString)
00 UDF(name#3)
01 +- name#3: string
```

```text
import org.apache.spark.sql.catalyst.expressions.BindReferences
val attrs = names.queryExecution.sparkPlan.output
val boundUDF = BindReferences.bindReference(resolvedUDF, attrs)

// Create an internal binary row, i.e. InternalRow
import org.apache.spark.sql.catalyst.encoders.ExpressionEncoder
val stringEncoder = ExpressionEncoder[String]
val row = stringEncoder.toRow("world")
```

Yay! It works!

```text
scala> boundUDF.eval(row)
res8: Any = Hello world
```

Just to show the regular execution path (i.e. how to execute an UDF in a context of a `Dataset`).

```scala
val q = names.select(hello($"name"))
```

```text
scala> q.show
+-----------+
|  UDF(name)|
+-----------+
|Hello Jacek|
|Hello Agata|
+-----------+
```
