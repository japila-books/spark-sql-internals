# EquivalentExpressions

`EquivalentExpressions` is...FIXME

[[internal-registries]]
.EquivalentExpressions's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| [[equivalenceMap]] `equivalenceMap`
| *Equivalent sets of expressions*, i.e. semantically equal expressions/Expression.md[expressions] by their `Expr` "representative"

Used when...FIXME
|===

=== [[addExprTree]] `addExprTree` Method

[source, scala]
----
addExprTree(expr: Expression): Unit
----

`addExprTree`...FIXME

NOTE: `addExprTree` is used when `CodegenContext` is requested to [subexpressionElimination](CodegenContext.md#subexpressionElimination) or [subexpressionEliminationForWholeStageCodegen](CodegenContext.md#subexpressionEliminationForWholeStageCodegen).

=== [[addExpr]] `addExpr` Method

[source, scala]
----
addExpr(expr: Expression): Boolean
----

`addExpr`...FIXME

[NOTE]
====
`addExpr` is used when:

* `EquivalentExpressions` is requested to <<addExprTree, addExprTree>>

* `PhysicalAggregation` is requested to spark-sql-PhysicalAggregation.md#unapply[destructure an Aggregate logical operator]
====

=== [[getAllEquivalentExprs]] Getting Equivalent Sets Of Expressions -- `getAllEquivalentExprs` Method

[source, scala]
----
getAllEquivalentExprs: Seq[Seq[Expression]]
----

`getAllEquivalentExprs` takes the values of all the <<equivalenceMap, equivalent sets of expressions>>.

`getAllEquivalentExprs` is used when `CodegenContext` is requested to [subexpressionElimination](CodegenContext.md#subexpressionElimination) or [subexpressionEliminationForWholeStageCodegen](CodegenContext.md#subexpressionEliminationForWholeStageCodegen).
