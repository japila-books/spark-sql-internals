# WindowFunction

`WindowFunction` is the <<contract, contract>> of <<implementations, function expressions>> that define a <<frame, WindowFrame>> in which the window operator must be executed.

=== [[frame]] Defining WindowFrame for Execution -- `frame` Method

[source, scala]
----
frame: WindowFrame
----

`frame` defines the `WindowFrame` for function execution, i.e. the `WindowFrame` in which the window operator must be executed.

`frame` is `UnspecifiedFrame` by default.

NOTE: `frame` is used when...FIXME
