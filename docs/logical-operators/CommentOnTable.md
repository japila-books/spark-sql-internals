# CommentOnTable Logical Command

`CommentOnTable` is a [Command](Command.md) that represents [COMMENT ON TABLE](../sql/AstBuilder.md#visitCommentTable) SQL command.

## Creating Instance

`CommentOnTable` takes the following to be created:

* <span id="child"> [LogicalPlan](LogicalPlan.md)
* <span id="comment"> Comment

`CommentOnTable` is created when:

* `AstBuilder` is requested to [parse COMMENT ON TABLE command](../sql/AstBuilder.md#visitCommentTable)

## Execution Planning

`CommentOnTable` is resolved to [AlterTableExec](../physical-operators/AlterTableExec.md) by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy.
