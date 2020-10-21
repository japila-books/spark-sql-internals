# CreateNamedStructLike

`CreateNamedStructLike` is the <<contract, base>> of <<implementations, Catalyst expressions>> that <<FIXME, FIXME>>.

[[contract]]
[source, scala]
----
package org.apache.spark.sql.catalyst.expressions

trait CreateNamedStructLike extends Expression {
  // no required properties (vals and methods) that have no implementation
}
----

[[nullable]]
`CreateNamedStructLike` is not <<Expression.md#nullable, nullable>>.

[[foldable]]
`CreateNamedStructLike` is <<Expression.md#foldable, foldable>> only if all <<valExprs, value expressions>> are.

[[implementations]]
.CreateNamedStructLikes (Direct Implementations)
[cols="1,2",options="header",width="100%"]
|===
| CreateNamedStructLike
| Description

| [[CreateNamedStruct]] <<spark-sql-Expression-CreateNamedStruct.md#, CreateNamedStruct>>
|

| [[CreateNamedStructUnsafe]] <<spark-sql-Expression-CreateNamedStructUnsafe.md#, CreateNamedStructUnsafe>>
|
|===

[[internal-registries]]
.CreateNamedStructLike's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1m,2",options="header",width="100%"]
|===
| Name
| Description

| dataType
| [[dataType]]

| nameExprs
| [[nameExprs]] <<Expression.md#, Catalyst expressions>> for names

| names
| [[names]]

| valExprs
| [[valExprs]] <<Expression.md#, Catalyst expressions>> for values
|===

=== [[checkInputDataTypes]] Checking Input Data Types -- `checkInputDataTypes` Method

[source, scala]
----
checkInputDataTypes(): TypeCheckResult
----

NOTE: `checkInputDataTypes` is part of the <<Expression.md#checkInputDataTypes, Expression Contract>> to verify (check the correctness of) the input data types.

`checkInputDataTypes`...FIXME

=== [[eval]] Evaluating Expression -- `eval` Method

[source, scala]
----
eval(input: InternalRow): Any
----

`eval` is part of the [Expression](Expression.md#eval) abstraction.

`eval`...FIXME
