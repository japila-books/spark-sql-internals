# Variable Substitution

Spark SQL (and Spark Thrift Server) supports [Variable Substitution](sql/VariableSubstitution.md) in SQL commands using syntax like `${var}`, `${system:var}`, and `${env:var}`.

!!! note
    `VariableSubstitution` is meant for SQL commands mainly (if not exclusively) since in programming languages there are other means to achieve it (e.g., [String Interpolation](https://docs.scala-lang.org/overviews/core/string-interpolation.html) in Scala).

## <span id="spark.sql.variable.substitute"> spark.sql.variable.substitute

[spark.sql.variable.substitute](configuration-properties.md#spark.sql.variable.substitute) configuration property is used to enable variable substitution.
