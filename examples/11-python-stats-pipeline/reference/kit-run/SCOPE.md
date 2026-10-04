# Scope

The theorem is partial correctness of the exact original compiled `run` function body, from bytecode instruction 0 through normal exit in a prepared single-interpreter, single-thread frame with an empty caller stack. Module initialization, argument binding, a separate termination theorem and reference-count implementation details are outside this boundary.

Every initial parameter is an arbitrary mathematical integer. Both cached and dynamic integer representations are admitted, as is aliasing when the payload constraints agree. The code address and allocation cursor are fresh relative to the existing heap; these restrictions express a well-formed runtime state and impose no numeric bound on integer values. Metadata not read by the body is symbolic. Unobserved cells and other heap allocations are framed or abstracted because the source contract observes only the returned tuple.

The result is `(a,b,n,min(a,b),max(a,b),max(a,b)-min(a,b),max(n,0),max(n,0)*(max(a,b)-min(a,b))+min(a,b))`. Incoming m, x, t, i and res are overwritten. Four entry claims partition a<=b versus a>b and the sign of n without excluding any integer input.

The loop invariant is `0 <= I <= N` and `Res = I*T`, for `N >= 0`, and includes the exit boundary. The final tuple is observed at `FinalNext-1`: BUILD_TUPLE is the last allocation, and the immediately following RETURN_VALUE consumes its reference at the top-level normal-exit boundary. All returned tuple fields are constrained. No execution-skipping rule or trusted claim is used.
