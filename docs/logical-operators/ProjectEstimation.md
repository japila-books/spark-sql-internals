# ProjectEstimation

`ProjectEstimation` is...FIXME

=== [[estimate]] Estimating Statistics and Query Hints of Project Logical Operator -- `estimate` Method

[source, scala]
----
estimate(project: Project): Option[Statistics]
----

`estimate`...FIXME

`estimate` is used when `BasicStatsPlanVisitor` is requested to [estimate statistics and query hints of a Project logical operator](BasicStatsPlanVisitor.md#visitProject).
