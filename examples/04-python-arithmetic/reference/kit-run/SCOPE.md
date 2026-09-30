# Verification scope

## Program boundary

The theorem boots the exact `/app/program.kpyc` image, executes its module body so that its `run` binding is produced by the supplied bytecode, then invokes that bound Python function through the fixed semantics with three symbolic Python integer objects. The body of `run`, including argument binding, the assignment `res = a * b + a - b`, tuple construction, and return control, executes under the immutable `python-3-14-6` semantics pinned at commit `e5d24a5429a4`. Eight entry claims partition only the fixed semantics' cached-small-int versus allocated-heap-int representation choices for the product, sum, and difference; their Boolean guards are exhaustive and collectively state one full-domain theorem.

## Input domain

`a`, `b`, and the incoming `res` range independently over all mathematical integers represented by the semantics' `#PyLongObject(Int)` payload. There are no guards or excluded integer values. The input `res` is intentionally unconstrained because the source overwrites it before reading it.

## Observable final state

The observed result is the returned Python object: it must be exactly a three-element tuple of Python integer objects whose payloads are constrained in order. Standard output and standard error start empty and are required to remain empty. Allocation identities, heap garbage, frame internals, and allocator advancement are not user-visible in the source contract and are framed existentially after execution.

## Intended property

If `run(a, b, res)` terminates for integer inputs, it returns `(a, b, a * b + a - b)`.

## Chosen contract readings

- “Take integer state bindings” is read as all integer triples, not only machine-sized or small cached integers, because Python integers and the selected model use unbounded integer payloads.
- “return final (a, b, res)” is read positionally as an exact three-element tuple. The final `a` and `b` are unchanged, while final `res` is the value assigned by the function.
- The caller-visible result and empty output streams are observed. Internal heap addresses and dead frames are not part of the docstring contract.
- The semantics registry reports proof support only; a concrete `kprover run` request returned `UNSUPPORTED_OPERATION`. This is an operation-level model boundary, not an input-domain restriction and not evidence of a program fault.
