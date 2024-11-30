# UserDefinedPythonFunction

`UserDefinedPythonFunction` represents a [user-defined Python function](#func).

## Creating Instance

`UserDefinedPythonFunction` takes the following to be created:

* <span id="name"> Name
* <span id="func"> `PythonFunction`
* <span id="dataType"> [DataType](../types/DataType.md)
* <span id="pythonEvalType"> Eval Type
* <span id="udfDeterministic"> `udfDeterministic` flag

`UserDefinedPythonFunction` is created when:

* `SparkConnectPlanner` is requested to `handleRegisterPythonUDF` (to [register a user-defined Python function](UDFRegistration.md#registerPython))

## Creating Column (to Execute PythonUDF) { #apply }

```scala
apply(
  exprs: Column*): Column
```

`apply` creates a [Column](../Column.md) with the [PythonUDF](#builder) for the given [Column expressions](../Column.md#expr).

## Creating PythonUDF { #builder }

```scala
builder(
  e: Seq[Expression]): Expression
```

`builder` creates a [PythonUDF](../expressions/PythonUDF.md) expression (for the given [Expression](../expressions/Expression.md)s).

---

`builder` is used when:

* `UDFRegistration` is requested to [register a named user-defined Python function](UDFRegistration.md#registerPython)
* `UserDefinedPythonFunction` is requested to [create a Column](#apply)
