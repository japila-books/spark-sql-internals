---
title: SetNamespaceCommand
---

# SetNamespaceCommand Leaf Logical Command

`SetNamespaceCommand` is a [leaf logical runnable command](LeafRunnableCommand.md) that represents the following SQL statement:

```antlr
USE [NAMESPACE | DATABASE | SCHEMA] identifier
```

## Creating Instance

`SetNamespaceCommand` takes the following to be created:

* <span id="namespace"> Multi-part namespace

`SetNamespaceCommand` is created when:

* `SparkSqlAstBuilder` is requested to parse [USE NAMESPACE](../sql/SparkSqlAstBuilder.md#visitUseNamespace) SQL statement
