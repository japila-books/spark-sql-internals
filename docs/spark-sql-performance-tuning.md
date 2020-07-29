# Spark SQL's Performance Tuning Tips and Tricks (aka Case Studies)

From time to time I'm lucky enough to find ways to optimize structured queries in Spark SQL. These findings (or discoveries) usually fall into a study category than a single topic and so the goal of *Spark SQL's Performance Tuning Tips and Tricks* chapter is to have a single place for the so-called tips and tricks.

. spark-sql-performance-tuning-groupBy-aggregation.md[Number of Partitions for groupBy Aggegration]

=== Others

. Avoid `ObjectType` as spark-sql-CollapseCodegenStages.md#insertWholeStageCodegen-ObjectType[it turns whole-stage Java code generation off].

. Keep spark-sql-CollapseCodegenStages.md#supportCodegen[whole-stage codegen requirements] in mind, in particular avoid physical operators with spark-sql-CodegenSupport.md#supportCodegen[supportCodegen] flag off.
