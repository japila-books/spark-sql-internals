# PushDownOperatorsToDataSource Logical Optimization

`PushDownOperatorsToDataSource` is a *logical optimization* that <<apply, pushes down operators to underlying data sources>> (i.e. <<spark-sql-LogicalPlan-DataSourceV2Relation.md#, DataSourceV2Relations>>) (before planning so that data source can report statistics more accurately).

Technically, `PushDownOperatorsToDataSource` is a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

`PushDownOperatorsToDataSource` is part of the [Push down operators to data source scan](../SparkOptimizer.md#PushDownOperatorsToDataSource) once-executed rule batch of the [SparkOptimizer](../SparkOptimizer.md).

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

=== [[pushDownRequiredColumns]] `pushDownRequiredColumns` Internal Method

[source, scala]
----
pushDownRequiredColumns(plan: LogicalPlan, requiredByParent: AttributeSet): LogicalPlan
----

`pushDownRequiredColumns` branches off per the input <<spark-sql-LogicalPlan.md#, logical operator>> (that is supposed to have at least one child node):

. For <<spark-sql-LogicalPlan-Project.md#, Project>> unary logical operator, `pushDownRequiredColumns` takes the <<expressions/Expression.md#references, references>> of the <<spark-sql-LogicalPlan-Project.md#projectList, project expressions>> as the required columns (attributes) and executes itself recursively on the <<spark-sql-LogicalPlan-Project.md#child, child logical operator>>
+
Note that the input `requiredByParent` attributes are not considered in the required columns.

. For <<spark-sql-LogicalPlan-Filter.md#, Filter>> unary logical operator, `pushDownRequiredColumns` adds the <<expressions/Expression.md#references, references>> of the <<spark-sql-LogicalPlan-Filter.md#condition, filter condition>> to the input `requiredByParent` attributes and executes itself recursively on the <<spark-sql-LogicalPlan-Filter.md#child, child logical operator>>

. For <<spark-sql-LogicalPlan-DataSourceV2Relation.md#, DataSourceV2Relation>> unary logical operator, `pushDownRequiredColumns`...FIXME

. For other logical operators, `pushDownRequiredColumns` simply executes itself (using [TreeNode.mapChildren](../catalyst/TreeNode.md#mapChildren)) recursively on the [child nodes](../catalyst/TreeNode.md#children) (logical operators)

`pushDownRequiredColumns` is used when `PushDownOperatorsToDataSource` logical optimization is requested to <<apply, execute>>.

=== [[FilterAndProject]][[unapply]] Destructuring Logical Operator -- `FilterAndProject.unapply` Method

[source, scala]
----
unapply(plan: LogicalPlan): Option[(Seq[NamedExpression], Expression, DataSourceV2Relation)]
----

`unapply` is part of `FilterAndProject` extractor object to destructure the input <<spark-sql-LogicalPlan.md#, logical operator>> into a tuple with...FIXME

`unapply` works with (matches) the following logical operators:

. For a <<spark-sql-LogicalPlan-Filter.md#, Filter>> with a <<spark-sql-LogicalPlan-DataSourceV2Relation.md#, DataSourceV2Relation>> leaf logical operator, `unapply`...FIXME

. For a <<spark-sql-LogicalPlan-Filter.md#, Filter>> with a <<spark-sql-LogicalPlan-Project.md#, Project>> over a <<spark-sql-LogicalPlan-DataSourceV2Relation.md#, DataSourceV2Relation>> leaf logical operator, `unapply`...FIXME

. For others, `unapply` returns `None` (i.e. does nothing / does not match)

NOTE: `unapply` is used exclusively when `PushDownOperatorsToDataSource` logical optimization is requested to <<apply, execute>>.
