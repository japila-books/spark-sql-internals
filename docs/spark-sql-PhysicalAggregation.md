# PhysicalAggregation -- Scala Extractor for Destructuring Aggregate Logical Operators

`PhysicalAggregation` is a Scala extractor to <<unapply, destructure an Aggregate logical operator>> into a four-element tuple with the following elements:

. Grouping spark-sql-Expression-NamedExpression.md[named expressions]

. [AggregateExpressions](expressions/AggregateExpression.md)

. Result spark-sql-Expression-NamedExpression.md[named expressions]

. Child spark-sql-LogicalPlan.md[logical operator]

[[ReturnType]]
.ReturnType
[source, scala]
----
(Seq[NamedExpression], Seq[AggregateExpression], Seq[NamedExpression], LogicalPlan)
----

TIP: See the document about http://docs.scala-lang.org/tutorials/tour/extractor-objects.html[Scala extractor objects].

=== [[unapply]] Destructuring Aggregate Logical Operator -- `unapply` Method

[source, scala]
----
type ReturnType =
  (Seq[NamedExpression], Seq[AggregateExpression], Seq[NamedExpression], LogicalPlan)

unapply(a: Any): Option[ReturnType]
----

`unapply` destructures the input `a` spark-sql-LogicalPlan-Aggregate.md[Aggregate] logical operator into a four-element <<ReturnType, ReturnType>>.

[NOTE]
====
`unapply` is used when...FIXME
====
