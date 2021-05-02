# Join Logical Operator

`Join` is a spark-sql-LogicalPlan.md#BinaryNode[binary logical operator], i.e. works with two logical operators. `Join` has a join type and an optional expression condition for the join.

`Join` is <<creating-instance, created>> when...FIXME

NOTE: CROSS JOIN is just an INNER JOIN with no join condition.

[[output]]
`Join` has catalyst/QueryPlan.md#output[output schema attributes]...FIXME

=== [[creating-instance]] Creating Join Instance

`Join` takes the following when created:

* [[left]] spark-sql-LogicalPlan.md[Logical plan] of the left side
* [[right]] spark-sql-LogicalPlan.md[Logical plan] of the right side
* [[joinType]] spark-sql-joins.md#join-types[Join type]
* [[condition]] Join condition (if available) as a expressions/Expression.md[Catalyst expression]
