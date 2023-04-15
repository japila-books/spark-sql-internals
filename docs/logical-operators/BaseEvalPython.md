---
title: BaseEvalPython
---

# BaseEvalPython Unary Logical Operators

`BaseEvalPython` is an [extension](#contract) of the [UnaryNode](LogicalPlan.md#UnaryNode) abstraction for [unary logical operators](#implementations) that can execute [PythonUDFs](#udfs).

## Contract

### udfs

```scala
udfs: Seq[PythonUDF]
```

[PythonUDF](../expressions/PythonUDF.md)s

### resultAttrs { #resultAttrs }

```scala
resultAttrs: Seq[Attribute]
```

Result [Attribute](../expressions/Attribute.md)s

Used when:

* `BaseEvalPython` is requested for the [output](#output) and [producedAttributes](#producedAttributes)

## Implementations

* [ArrowEvalPython](ArrowEvalPython.md)
* `BatchEvalPython`
