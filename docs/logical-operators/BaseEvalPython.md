---
title: BaseEvalPython
---

# BaseEvalPython Unary Logical Operators

`BaseEvalPython` is an [extension](#contract) of the [UnaryNode](LogicalPlan.md#UnaryNode) abstraction for [unary logical operators](#implementations) that execute `PythonUDF`s.

## Contract

### udfs

```scala
udfs: Seq[PythonUDF]
```

`PythonUDF`s

### resultAttrs { #resultAttrs }

```scala
resultAttrs: Seq[Attribute]
```

Result [Attribute](../expressions/Attribute.md)s

Used when:

* `BaseEvalPython` is requested for the [output](#output) and [producedAttributes](#producedAttributes)

## Implementations

* `ArrowEvalPython`
* `BatchEvalPython`
