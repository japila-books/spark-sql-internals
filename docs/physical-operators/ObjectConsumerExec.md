# ObjectConsumerExec -- Unary Physical Operators with Child Physical Operator with One-Attribute Output Schema

`ObjectConsumerExec` is the <<contract, contract>> of <<implementations, unary physical operators>> with the child physical operator using a one-attribute <<catalyst/QueryPlan.md#output, output schema>>.

[[contract]]
[source, scala]
----
package org.apache.spark.sql.execution

trait ObjectConsumerExec extends UnaryExecNode {
  // No properties (vals and methods) that have no implementation
}
----

[[references]]
`ObjectConsumerExec` requests the child physical operator for the <<catalyst/QueryPlan.md#outputSet, output schema attribute set>> when requested for the <<catalyst/QueryPlan.md#references, references>>.

[[implementations]]
.ObjectConsumerExecs
[cols="1,2",options="header",width="100%"]
|===
| ObjectConsumerExec
| Description

| `AppendColumnsWithObjectExec`
| [[AppendColumnsWithObjectExec]]

| <<spark-sql-SparkPlan-MapElementsExec.md#, MapElementsExec>>
| [[MapElementsExec]]

| `MapPartitionsExec`
| [[MapPartitionsExec]]

| <<spark-sql-SparkPlan-SerializeFromObjectExec.md#, SerializeFromObjectExec>>
| [[SerializeFromObjectExec]]
|===

=== [[inputObjectType]] `inputObjectType` Method

[source, scala]
----
inputObjectType: DataType
----

`inputObjectType` simply returns the <<expressions/Expression.md#dataType, data type>> of the single <<catalyst/QueryPlan.md#output, output attribute>> of the child physical operator.

NOTE: `inputObjectType` is used when...FIXME
