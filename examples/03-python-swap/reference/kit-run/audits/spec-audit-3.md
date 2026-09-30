# Specification audit 3

## Artifacts examined

- `inputs/spec.k` (`sha256 203dab4a7154930184495a0b36136974a91424857adace8f623a33b89e1563a4`)
- `inputs/verification.k` (`sha256 c63823466432ab0525bd1c1c160c401e72a657e8207d9c7357d6182b284ac034`)
- `inputs/program.k`, `inputs/SCOPE.md` (`sha256 6ec96f2a521ac7d97eb20156bd333b58d11a79b34ea33d29608ab659e99f36d7`), `/app/program.py`, and `/app/program.kpyc`
- `audits/test_contract.py` (`sha256 9ee480e3d2e29b704381fd3740a9436704d0052e446ab566f72fa28b1aa7d44d`)
- Construction session `2f8278f9-afcf-4fe6-b17b-882f0db1524d`, pinned `python-3-14-6` revision `e5d24a5429a4`

## Theorem and adequacy

The claim still starts from the complete initial configuration, boots the exact supplied bytecode image, invokes its real `run` binding on arbitrary integer values `A`, `B`, and `R`, and stops at the fixed semantics' C-call return boundary. The final heap is framed by an existential map, while the `ensures` clause applies `isSwapResult(A,B,R,AID,BID,RID,TUPLE,FINAL)`.

In plain language, `isSwapResult` is true exactly when the original input addresses still contain integer values `A`, `B`, and `R`, and the returned address contains a tuple whose references are `(BID,AID,AID)`. This is the same postcondition previously written directly as a final map pattern. Factoring it into a predicate changes proof presentation, not domain or meaning.

- **B1:** PASS. All three inputs remain independent unbounded K integers with no guard.
- **B2:** PASS with the recorded proof-only instrumentation boundary; every construct in the image is represented by the pinned semantics.
- **B3:** PASS. The predicate denotes precisely the intended value-and-alias property.
- **B4:** PASS. Source assignments, compiled opcodes, exact image constant, and the predicate agree.

## Summary faithfulness

`isSwapResult` is the only symbol in `VERIFICATION-SUMMARIES`.

- Its positive equation matches exact integer object payloads for the three original argument identities and an exact tuple payload `(BID,AID,AID)` at the returned identity.
- Its `owise` equation returns false for the complement, so the function is total. The equations cannot overlap because `owise` applies only where the positive equation does not.
- There is no recursion and no operational term is rewritten; the predicate only observes its explicit map argument.
- The pinned numeric type IDs on the positive LHS are `1026` (`#idInt`) and `1033` (`#idTuple`) from revision `e5d24a5429a4`; this avoids illegal function symbols on another function's LHS without changing meaning.
- Hand evaluation returns true for heaps representing `(1,2,3)->(2,1,1)`, `(-5,0,9)->(0,-5,-5)`, and `(0,0,0)->(0,0,0)`, and false when either tuple position is changed, when the result is not a tuple, or when any input payload differs.

Independent finite evidence: `PYTHONPATH=/app python3 audits/test_contract.py` exited 0 with `checked=1728 mismatches=0`. The sample is the Cartesian cube of 12 values covering `-10**80`, `10**80`, negatives, zero, and the model's small-int boundaries 255/256/257. The oracle directly calls `/app/program.py` and checks both values and Python object identities; it does not reuse the K equations. This evidence is empirical and does not replace the symbolic proof.

## Mechanical checks and repair evidence

1. Proof attempt 2 reached the expected return term `#cReturn(#verificationReturn(4161,4162,4163),4164) ~> #dispatch`; then PyK's final implication query crashed with `RuntimeError: Empty response received` after 423 seconds. The large explicit final-map subsumption was therefore factored into the observational predicate.
2. Validation attempt 4, task `25d50a9b-0cbc-40ee-b27e-c11016751acf`, exited 113 because `#idInt` and `#idTuple` function symbols were illegal on the predicate rule's LHS. The rules were mechanically repaired to the pinned values 1026 and 1033.
3. `kprover validate --session 2f8278f9-afcf-4fe6-b17b-882f0db1524d --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program.k --task-timeout 1800` — exit 0, validation attempt 5, task `92862059-b291-4727-87d5-cd51ac9d432e`; `task.status=completed`, `task.result.valid=true`, with `kompile` and `kprove` exits 0.

There are no loops, circularities, cross-claim dependencies, trusted claims, or finite domain bounds.

VERDICT: PASS
REASON: The refactored claim compiles and its total heap predicate faithfully states the unchanged full-domain swap result and aliasing property.
