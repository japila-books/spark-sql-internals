# Logical Operators

**Logical Operators** (_Logical Relational Operators_) are building blocks of logical query plans.

**Logical Query Plan** is a tree of [nodes](../catalyst/TreeNode.md) of logical operators that in turn can have (trees of) [Catalyst expressions](../expressions/Expression.md). In other words, there are _at least_ two trees at every level (operator).

The main abstraction is [LogicalPlan](LogicalPlan.md) that is a recursive data structure with zero, one, two or more child logical operators:

* [LeafNode](LeafNode.md)
* [UnaryNode](LogicalPlan.md#UnaryNode)
* [BinaryNode](LogicalPlan.md#BinaryNode)

Among the logical operators are [Command](Command.md)s.
