# Physical Operators

**Physical Operators** (_Physical Relational Operators_) are building blocks of physical query plans.

**Physical Query Plan** is a tree of [nodes](../catalyst/TreeNode.md) of physical operators that in turn can have (trees of) [Catalyst expressions](../expressions/Expression.md). In other words, there are _at least_ two trees at every level (operator).

The main abstraction is [SparkPlan](SparkPlan.md) that is a recursive data structure with zero, one, two or more child logical operators:

* `LeafExecNode`
* [UnaryExecNode](UnaryExecNode.md)
* `BinaryExecNode`
