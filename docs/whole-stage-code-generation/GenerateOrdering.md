# GenerateOrdering

`GenerateOrdering` is...FIXME

=== [[create]] Creating BaseOrdering -- `create` Method

[source, scala]
----
create(ordering: Seq[SortOrder]): BaseOrdering
create(schema: StructType): BaseOrdering
----

`create` is part of the [CodeGenerator](CodeGenerator.md#create) abstraction.

`create`...FIXME

=== [[genComparisons]] `genComparisons` Method

[source, scala]
----
genComparisons(ctx: CodegenContext, schema: StructType): String
----

`genComparisons`...FIXME

NOTE: `genComparisons` is used when...FIXME
