---
title: Transform
---

# Transform Function Expressions

`Transform` is an [extension](#contract) of the [Expression](../expressions/Expression.md) abstraction for [transform functions](#implementations).

## Contract

### <span id="arguments"> Arguments

```java
Expression[] arguments()
```

[Expression](../expressions/Expression.md)s of the arguments of this transform function

### <span id="name"> Name

```java
String name()
```

### <span id="references"> References

```java
NamedReference[] references()
```

## Implementations

* [ApplyTransform](ApplyTransform.md)
* [RewritableTransform](RewritableTransform.md)
