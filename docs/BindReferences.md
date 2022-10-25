# BindReferences

`BindReferences` utility allows to bind (_resolve_) [one](#bindReference) or [multiple](#bindReferences) `AttributeReference`s.

## <span id="bindReference"> Binding One AttributeReference

```scala
bindReference[A <: Expression](
  expression: A,
  input: AttributeSeq,
  allowFailures: Boolean = false): A
```

For every `AttributeReference` expression in the given `expression`, `bindReference` finds the `ExprId` in the `input` schema and creates a [BoundReference](expressions/BoundReference.md) expression.

---

`bindReference` throws an `IllegalStateException` when an `AttributeReference` could not be found in the input schema:

```text
Couldn't find [a] in [input]
```

---

`bindReference` is used when:

* `ExpressionEncoder` is requested to [resolveAndBind](ExpressionEncoder.md#resolveAndBind)
* `BindReferences` is used to [bind multiple references](#bindReferences)
* _others_

## <span id="bindReferences"> Binding Multiple AttributeReferences

```scala
bindReferences[A <: Expression](
  expressions: Seq[A],
  input: AttributeSeq): Seq[A]
```

`bindReferences` [bindReference](#bindReference) of all the given `expressions` to the `input` schema.
