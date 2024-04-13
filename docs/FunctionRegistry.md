# FunctionRegistry

`FunctionRegistry` is an [extension](#contract) of the [FunctionRegistryBase](FunctionRegistryBase.md) abstraction for [function registries](#implementations) with functions that produce a result of [Expression](expressions/Expression.md) type.

## Implementations

* `EmptyFunctionRegistry`
* [SimpleFunctionRegistry](SimpleFunctionRegistry.md)

## Accessing FunctionRegistry

`FunctionRegistry` is available using [SessionState.functionRegistry](SessionState.md#functionRegistry).

```scala
import org.apache.spark.sql.catalyst.analysis.FunctionRegistry
assert(spark.sessionState.functionRegistry.isInstanceOf[FunctionRegistry])
```

## <span id="builtin"> Built-In Functions

```scala
builtin: SimpleFunctionRegistry
```

`builtin` creates a new [SimpleFunctionRegistry](SimpleFunctionRegistry.md) and [registers](SimpleFunctionRegistryBase.md#internalRegisterFunction) all the [built-in function expressions](#expressions).

---

`builtin` is used when:

* `FunctionRegistry` utility is used for [functionSet](#functionSet)
* `SessionCatalog` is requested to [isTemporaryFunction](SessionCatalog.md#isTemporaryFunction) and [reset](SessionCatalog.md#reset)
* `DropFunctionCommand` and `RefreshFunctionCommand` commands are executed
* `BaseSessionStateBuilder` is requested for a [FunctionRegistry](BaseSessionStateBuilder.md#functionRegistry)

## <span id="logicalPlan"> logicalPlan

```scala
type TableFunctionBuilder = Seq[Expression] => LogicalPlan
logicalPlan[T <: LogicalPlan : ClassTag](
  name: String): (String, (ExpressionInfo, TableFunctionBuilder))
```

`logicalPlan` [builds info and builder](FunctionRegistryBase.md#build) for the given `name` table function and returns a tuple of the following:

* The given name
* The info
* A function that uses the builder to build a [LogicalPlan](logical-operators/LogicalPlan.md) for a given [Expression](expressions/Expression.md)s

---

`logicalPlan` is used when:

* [TableFunctionRegistry](TableFunctionRegistry.md) is created (and [registers range table function](TableFunctionRegistry.md#logicalPlans))

## <span id="generator"> generator

```scala
type TableFunctionBuilder = Seq[Expression] => LogicalPlan
generator[T <: Generator : ClassTag](
  name: String,
  outer: Boolean = false): (String, (ExpressionInfo, TableFunctionBuilder))
```

`generator`...FIXME

---

`generator` is used when:

* [TableFunctionRegistry](TableFunctionRegistry.md) is created (and [registers generate table functions](TableFunctionRegistry.md#logicalPlans))

## Expression { #expression }

```scala
expression[T <: Expression : ClassTag](
  name: String,
  setAlias: Boolean = false,
  since: Option[String] = None): (String, (ExpressionInfo, FunctionBuilder))
```

`expression` [builds a function builder](FunctionRegistryBase.md#build) for the given `name` and `since`.

`expression` creates a new builder that accepts [Expression](expressions/Expression.md)s and (_among other things_) asserts that no `NamedArgumentExpression` is among the given `Expression`s. If there are any, `expression` reports an `AnalysisException`:

```text
Named parameters are not supported for function [functionName];
please retry the query with positional arguments to the function call instead.
```

---

`expression` is used when:

* `FunctionRegistry` is requested for the [built-in function expressions](#expressions) (incl. [expressionGeneratorOuter](#expressionGeneratorOuter))
