# ResolveCatalogs Logical Resolution Rule

`ResolveCatalogs` is a logical rule (`Rule[LogicalPlan]`).

`ResolveCatalogs` is part of [Resolution](../Analyzer.md#Resolution) batch of [Logical Analyzer](../Analyzer.md).

## Creating Instance

`ResolveCatalogs` takes the following to be created:

* <span id="catalogManager"> [CatalogManager](../connector/catalog/CatalogManager.md)

`ResolveCatalogs` is created when:

* `Analyzer` is requested for [batches](../Analyzer.md#batches)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` resolves catalogs from the multi-part identifiers in SQL statements and converts the following logical operators to the corresponding v2 commands if the resolved catalog is not the session catalog (aka **spark_catalog**).

ParsedStatement                    | Command
-----------------------------------|--------
AlterTableAddColumnsStatement      | AlterTable
AlterTableAlterColumnStatement     | AlterTable
AlterTableRenameColumnStatement    | AlterTable
AlterTableDropColumnsStatement     | AlterTable
AlterTableSetPropertiesStatement   | AlterTable
AlterTableUnsetPropertiesStatement | AlterTable
AlterTableSetLocationStatement     | AlterTable
AlterViewSetPropertiesStatement    | throws a `AnalysisException`
AlterViewUnsetPropertiesStatement  | throws a `AnalysisException`
RenameTableStatement               | RenameTable
DescribeColumnStatement            | throws a `AnalysisException`
[CreateTableStatement](../logical-operators/CreateTableStatement.md) | [CreateV2Table](../logical-operators/CreateV2Table.md)
[CreateTableAsSelectStatement](../logical-operators/CreateTableAsSelectStatement.md) | CreateTableAsSelect
RefreshTableStatement              | RefreshTable
ReplaceTableStatement              | ReplaceTable
ReplaceTableAsSelectStatement      | ReplaceTableAsSelect
DropTableStatement                 | DropTable
DropViewStatement                  | throws a `AnalysisException`
CreateNamespaceStatement           | CreateNamespace
[UseStatement](../logical-operators/UseStatement.md) | [SetCatalogAndNamespace](../logical-operators/SetCatalogAndNamespace.md)
[ShowCurrentNamespaceStatement](../logical-operators/ShowCurrentNamespaceStatement.md) | [ShowCurrentNamespace](../logical-operators/ShowCurrentNamespace.md)

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
