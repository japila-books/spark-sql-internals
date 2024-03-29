# Inline

`Inline` is a [UnaryExpression](UnaryExpression.md) and a `CollectionGenerator`.

`Inline` is created by `inline` and `inline_outer` standard functions.

```text
// Query with inline function
val q = spark.range(1)
  .selectExpr("inline(array(struct(1, 'a'), struct(2, 'b')))")
val logicalPlan = q.queryExecution.analyzed
scala> println(logicalPlan.numberedTreeString)
00 Project [col1#61, col2#62]
01 +- Generate inline(array(named_struct(col1, 1, col2, a), named_struct(col1, 2, col2, b))), false, false, [col1#61, col2#62]
02    +- Range (0, 1, step=1, splits=Some(8))

// Query with inline_outer function
val q = spark.range(1)
  .selectExpr("inline_outer(array(struct(1, 'a'), struct(2, 'b')))")
val logicalPlan = q.queryExecution.analyzed
scala> println(logicalPlan.numberedTreeString)
00 Project [col1#69, col2#70]
01 +- Generate inline(array(named_struct(col1, 1, col2, a), named_struct(col1, 2, col2, b))), false, true, [col1#69, col2#70]
02    +- Range (0, 1, step=1, splits=Some(8))

import org.apache.spark.sql.catalyst.plans.logical.Generate
// get is safe since there is Generate logical operator
val generator = logicalPlan.collectFirst { case g: Generate => g.generator }.get
import org.apache.spark.sql.catalyst.expressions.Inline
val inline = generator.asInstanceOf[Inline]

// Inline Generator expression is also CollectionGenerator
scala> inline.collectionType.catalogString
res1: String = array<struct<col1:int,col2:string>>
```
