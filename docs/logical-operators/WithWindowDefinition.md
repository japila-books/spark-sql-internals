---
title: WithWindowDefinition
---

# WithWindowDefinition Unary Logical Operator

[[windowDefinitions]][[child]]
`WithWindowDefinition` is a spark-sql-LogicalPlan.md#UnaryNode[unary logical plan] with a single `child` logical plan and a `windowDefinitions` lookup table of spark-sql-Expression-WindowSpecDefinition.md[WindowSpecDefinition] per name.

[[creating-instance]]
`WithWindowDefinition` is created exclusively when `AstBuilder` sql/AstBuilder.md#withWindows[parses window definitions].

[[output]]
The catalyst/QueryPlan.md#output[output schema] of `WithWindowDefinition` is exactly the output attributes of the <<child, child>> logical operator.

[[example]]
[source, scala]
----
// Example with window specification alias and definition
val sqlText = """
  SELECT count(*) OVER anotherWindowSpec
  FROM range(5)
  WINDOW
    anotherWindowSpec AS myWindowSpec,
    myWindowSpec AS (
      PARTITION BY id
      RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )
"""

import spark.sessionState.{analyzer, sqlParser}
val parsedPlan = sqlParser.parsePlan(sqlText)

scala> println(parsedPlan.numberedTreeString)
00 'WithWindowDefinition Map(anotherWindowSpec -> windowspecdefinition('id, RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), myWindowSpec -> windowspecdefinition('id, RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))
01 +- 'Project [unresolvedalias(unresolvedwindowexpression('count(1), WindowSpecReference(anotherWindowSpec)), None)]
02    +- 'UnresolvedTableValuedFunction range, [5]

val plan = analyzer.execute(parsedPlan)
scala> println(plan.numberedTreeString)
00 Project [count(1) OVER (PARTITION BY id RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)#75L]
01 +- Project [id#73L, count(1) OVER (PARTITION BY id RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)#75L, count(1) OVER (PARTITION BY id RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)#75L]
02    +- Window [count(1) windowspecdefinition(id#73L, RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS count(1) OVER (PARTITION BY id RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)#75L], [id#73L]
03       +- Project [id#73L]
04          +- Range (0, 5, step=1, splits=None)
----
