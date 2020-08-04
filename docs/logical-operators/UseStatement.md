# UseStatement Parsed Statement

`UseStatement` is a [ParsedStatement](ParsedStatement.md) that represents [USE NAMESPACE](../sql/AstBuilder.md#visitUse) SQL statement.

!!! info
    `UseStatement` is resolved to [SetCatalogAndNamespace](SetCatalogAndNamespace.md) logical command when [ResolveCatalogs](../logical-analysis-rules/ResolveCatalogs.md) logical analyzer rule is executed.

## Creating Instance

`UseStatement` takes the following to be created:

* <span id="isNamespaceSet"> `isNamespaceSet` flag (that indicates whether `NAMESPACE` keyword was used or not)
* <span id="nameParts"> Namespace Parts

`UseStatement` is created when `AstBuilder` is requested to [visitUse](../sql/AstBuilder.md#visitUse).
