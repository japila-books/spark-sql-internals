# CodegenFallback Expressions

`CodegenFallback` is an extension of the [Expression](Expression.md) abstraction for [Catalyst expressions](#implementations) that do not support [Java code generation](../whole-stage-code-generation/index.md) and [fall back to interpreted mode](#doGenCode) (aka _fallback mode_).

`CodegenFallback` is used when:

* [CollapseCodegenStages](../physical-optimizations/CollapseCodegenStages.md) physical optimization is executed (and [enforce whole-stage codegen requirements for Catalyst expressions](../physical-optimizations/CollapseCodegenStages.md#supportCodegen-Expression))
* `Generator` expressions is requested to [supportCodegen](Generator.md#supportCodegen)
* `EquivalentExpressions` is requested to [childrenToRecurse](../subexpression-elimination/EquivalentExpressions.md#childrenToRecurse) and [commonChildrenToRecurse](../subexpression-elimination/EquivalentExpressions.md#commonChildrenToRecurse)

## Implementations

* [ArrayFilter](ArrayFilter.md)
* [CallMethodViaReflection](CallMethodViaReflection.md)
* [ImperativeAggregate](ImperativeAggregate.md)
* [JsonToStructs](JsonToStructs.md)
* _others_

## <span id="doGenCode"> Generating Java Source Code

```scala
doGenCode(
  ctx: CodegenContext,
  ev: ExprCode): ExprCode
```

`doGenCode` is part of the [Expression](Expression.md#doGenCode) abstraction.

---

`doGenCode` requests the input `CodegenContext` to add itself to the [references](../whole-stage-code-generation/CodegenContext.md#references).

`doGenCode` [walks down the expression tree](../catalyst/TreeNode.md#foreach) to find [Nondeterministic](Nondeterministic.md) expressions. For every `Nondeterministic` expression, `doGenCode` does the following:

1. Requests the input `CodegenContext` to add it to the [references](../whole-stage-code-generation/CodegenContext.md#references)

1. Requests the input `CodegenContext` to [addPartitionInitializationStatement](../whole-stage-code-generation/CodegenContext.md#addPartitionInitializationStatement) that is a Java code block as follows:

    ```text
    ((Nondeterministic) references[[childIndex]])
      .initialize(partitionIndex);
    ```

In the end, `doGenCode` generates a plain Java source code block that is one of the following code blocks per the [nullable](Expression.md#nullable) flag. `doGenCode` copies the input `ExprCode` with the code block added (as the `code` property).

=== "`nullable` enabled"

    ```text
    [placeHolder]
    Object [objectTerm] = ((Expression) references[[idx]]).eval([input]);
    boolean [isNull] = [objectTerm] == null;
    [javaType] [value] = [defaultValue];
    if (![isNull]) {
      [value] = ([boxedType]) [objectTerm];
    }
    ```

=== "`nullable` disabled"

    ```text
    [placeHolder]
    Object [objectTerm] = ((Expression) references[[idx]]).eval([input]);
    [javaType] [value] = ([boxedType]) [objectTerm];
    ```

## <span id="demo"> Demo: CurrentTimestamp with nullable disabled

```scala
import org.apache.spark.sql.catalyst.expressions.CurrentTimestamp
val currTimestamp = CurrentTimestamp()

import org.apache.spark.sql.catalyst.expressions.codegen.CodegenFallback
assert(currTimestamp.isInstanceOf[CodegenFallback], "CurrentTimestamp should be a CodegenFallback")

assert(currTimestamp.nullable == false, "CurrentTimestamp should not be nullable")
```

```scala
import org.apache.spark.sql.catalyst.expressions.codegen.{CodegenContext, ExprCode}
val ctx = new CodegenContext
// doGenCode is used when Expression.genCode is executed
val ExprCode(code, _, _) = currTimestamp.genCode(ctx)
```

```scala
println(code)
```

```text
Object obj_0 = ((Expression) references[0]).eval(null);
        long value_0 = (Long) obj_0;
```
