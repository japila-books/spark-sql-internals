# BindReferences

`BindReferences` utility allows [bindReferences](#bindReferences).

## <span id="bindReferences"> bindReferences

```scala
bindReference[A <: Expression](
  expression: A,
  input: AttributeSeq,
  allowFailures: Boolean = false): A
bindReferences[A <: Expression](
  expressions: Seq[A],
  input: AttributeSeq): Seq[A] // (1)!
```

1. `bindReference` of all the given `expressions` to the `input` schema

For every `AttributeReference` expression in the given `expression`, `bindReferences` finds the `ExprId` in the `input` schema and creates a [BoundReference](expressions/BoundReference.md) expression.

`bindReferences` throws an `IllegalStateException` when an `AttributeReference` could not be found in the input schema:

```text
Couldn't find [a] in [input]
```

---

`bindReferences` is used when:

* `ExpressionEncoder` is requested to [resolveAndBind](ExpressionEncoder.md#resolveAndBind)
* _others_
