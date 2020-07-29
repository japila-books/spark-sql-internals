title: ResolvedHint

# ResolvedHint Unary Logical Operator

`ResolvedHint` is a spark-sql-LogicalPlan.md#UnaryNode[unary logical operator] that...FIXME

`ResolvedHint` is <<creating-instance, created>> when...FIXME

[[output]]
When requested for catalyst/QueryPlan.md#output[output schema], `ResolvedHint` uses the output of the child logical operator.

[[doCanonicalize]]
`ResolvedHint` simply requests the <<child, child logical operator>> for the <<catalyst/QueryPlan.md#doCanonicalize, canonicalized version>>.

=== [[creating-instance]] Creating ResolvedHint Instance

`ResolvedHint` takes the following when created:

* [[child]] Child spark-sql-LogicalPlan.md[logical operator]
* [[hints]] spark-sql-HintInfo.md[Query hints]
