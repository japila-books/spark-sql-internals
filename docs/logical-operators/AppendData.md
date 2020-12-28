# AppendData Logical Command

`AppendData` is a <<spark-sql-LogicalPlan.md#, logical operator>> that represents appending data (the result of executing a <<query, structured query>>) to a <<table, table>> (with the <<isByName, columns matching>> by <<byName, name>> or <<byPosition, position>>) in [DataSource V2](../new-and-noteworthy/datasource-v2.md).

`AppendData` is <<creating-instance, created>> (indirectly via <<byName, byName>> or <<byPosition, byPosition>> factory methods) only for tests.

NOTE: `AppendData` has replaced the deprecated <<WriteToDataSourceV2.md#, WriteToDataSourceV2>> logical operator.

[[creating-instance]]
`AppendData` takes the following to be created:

* [[table]] `NamedRelation` for the table (to append data to)
* [[query]] <<spark-sql-LogicalPlan.md#, Logical operator>> (for the query)
* [[isByName]] `isByName` flag

[[children]]
`AppendData` has a [single child logical operator](../catalyst/TreeNode.md#children) that is exactly the <<query, logical operator>>.

`AppendData` is resolved by [ResolveOutputRelation](../logical-analysis-rules/ResolveOutputRelation.md) logical resolution rule.

`AppendData` is planned (_replaced_) to <<WriteToDataSourceV2Exec.md#, WriteToDataSourceV2Exec>> physical operator (when the <<table, table>> is a <<DataSourceV2Relation.md#, DataSourceV2Relation>> logical operator).

=== [[byName]] `byName` Factory Method

[source, scala]
----
byName(table: NamedRelation, df: LogicalPlan): AppendData
----

`byName` simply creates a <<AppendData, AppendData>> logical operator with the <<isByName, isByName>> flag on (`true`).

NOTE: `byName` seems used only for tests.

=== [[byPosition]] `byPosition` Factory Method

[source, scala]
----
byPosition(table: NamedRelation, query: LogicalPlan): AppendData
----

`byPosition` simply creates a <<AppendData, AppendData>> logical operator with the <<isByName, isByName>> flag off (`false`).

NOTE: `byPosition` seems used only for tests.
