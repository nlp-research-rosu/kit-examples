# Scope

The theorem executes the exact compiled body of `run(n, i, count)` from instruction 0 to normal exit in a prepared single-interpreter, single-thread function frame with no caller frame. Module creation, call binding, and reference-count implementation details are outside this boundary.

Inputs are arbitrary mathematical Python integers, including negative n and arbitrary initial i/count (both overwritten). Object references may alias when their payload constraints agree. Integers can be cached static objects or dynamic heap objects; no bound on their values is imposed. The allocation cursor is above all existing dynamic object addresses. Code metadata not read by this body is symbolic.

For n >= 0 the returned tuple is (n, n, ceil(n/2)); for n < 0 it is (n, 0, 0). The postcondition uses 2*count = n + (n mod 2), an exact characterization of ceil(n/2) for nonnegative n. The tuple is identified by the last allocated address: BUILD_TUPLE is the final allocation and RETURN_VALUE consumes its stack reference at top-level normal exit in these semantics. Other heap allocations are unobserved.

The loop invariant covers 0 <= i <= n, n >= 0, and 2*count = i + (i mod 2). It includes the exit boundary i=n. The loop is proved symbolically, not by testing a finite input range. This is partial correctness under the fixed python-3-14-6 semantics, not a termination theorem.
